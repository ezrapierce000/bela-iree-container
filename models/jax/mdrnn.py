
import jax
import functools
from iree.jax import Program
from jax.nn import relu
from jax.nn import sigmoid
from jax.nn import tanh
from jax import numpy as jnp
from jax import random as jrandom, lax, jit
import numpy as np
from flax import linen as nn
from collections import namedtuple

# JAX random number generation keys
key = jax.random.PRNGKey(42)
k1, k2, k3 = jax.random.split(key, 3)

# Model Hyperparameters
hidden_units=64
num_mixtures=5
layers=2
out_dim=2
sigma_temp = 1.0

Params = namedtuple("params", "x,c,h")

x = jnp.ones(out_dim)
cell_state = jnp.ones((1, hidden_units))
hidden_state = jnp.ones((1, hidden_units))

def_mus = jnp.ones((1, num_mixtures*out_dim))
def_sigs = jnp.ones((1, num_mixtures*out_dim))
def_pis = jnp.ones((1, num_mixtures))

params = Params(x, cell_state, hidden_state)


class MDRNN(nn.Module):
    @nn.compact
    def __call__(self, carry, inputs):
      # LSTM layer 1
      carry, inputs = nn.OptimizedLSTMCell()(carry,inputs)
      # LSTM layer 2
      carry, outputs = nn.OptimizedLSTMCell()(carry,inputs)
      # Three Dense layers that predict weights, centres & scales of gaussians
      mdn_mus = nn.Dense(num_mixtures*out_dim)(outputs)
      mdn_sigmas = nn.elu(nn.Dense(num_mixtures*out_dim)(outputs))
      mdn_pis = nn.softmax(nn.Dense(num_mixtures)(outputs))
      # m = jnp.array(jax.random.choice(k1, mdn_pis), int)[0]
      return self.sample_from_output(mdn_mus, mdn_sigmas, mdn_pis)

    def sample_from_output(self, mus, sigmas, pis):
      m = jnp.array(jax.random.choice(k1, pis), int)[0]
      # m = np.random.choice(range(len(pis)), p=pis)
      mus_vector = lax.dynamic_slice_in_dim(mus, m * out_dim, out_dim, axis=1)
      sig_vector = lax.dynamic_slice_in_dim(sigmas, m * out_dim, out_dim, axis=1)
      scale_matrix = jnp.identity(out_dim) * sig_vector  # scale matrix from diag
      cov_matrix = jnp.matmul(scale_matrix, scale_matrix.T)  # cov is scale squared.
      cov_matrix = cov_matrix * sigma_temp  # adjust for sigma temperature
      sample = jax.random.multivariate_normal(k2, mus_vector, cov_matrix, (1,1))
      return sample

mdrnn = MDRNN()

@jit
def init_params(rng):
  params = mdrnn.init(rng, (cell_state, hidden_state), x)['params']
  return params

# Get initial parameters
params = init_params(k3)

class Empi(Program):

  _params = params
  _cell_state = cell_state
  _hidden_state = hidden_state

  def run(self, x=Program.like(x)):
    sample = self._lstm((self._cell_state,self._hidden_state), x)
    return sample

  @Program.kernel
  def _lstm(carry, inp):
    sample = mdrnn.apply({'params': params}, carry, inp)
    return sample

model = Empi()

print(Program.get_mlir_module(model))
"""
f = functools.partial(mdrnn.apply, params)
z = jax.xla_computation(f)((cell_state, hidden_state), x)
with open("t2.dot", "w") as f:
    f.write(z.as_hlo_dot_graph())
"""