
import jax
from iree.jax import Program
from jax.nn import relu
from jax.nn import sigmoid
from jax.nn import tanh
from jax import numpy as jnp
from jax import random as jrandom, lax, jit
from numpy import random as nrandom
from flax import linen as nn
from collections import namedtuple

mdrnn_units = 32
mdrnn_mixes = 5
mdrnn_layers = 2

# Model Hyperparameters

hidden_units=64
num_mixtures=5
layers=2
out_dim=2


Params = namedtuple("params", "x,c,h")

x = jnp.ones(out_dim)
cell_state = jnp.ones((1, hidden_units))
hidden_state = jnp.ones((1, hidden_units))

params = Params(x, cell_state, hidden_state)

@jit
def softmax(w, t=1.0):
  e = jnp.array(w) / t
  e -= e.max()
  e = jnp.exp(e)
  dist = e / jnp.sum(e)
  return dist


def sample_from_output(mus, sigmas, pis):
  pis = softmax(pis)
  m = 5 # nrandom.choice(range(len(pis)), p=pis)
  mus_vector = mus[m * out_dim:(m + 1) * out_dim]
  sig_vector = sigmas# [m * out_dim:(m + 1) * out_dim]
  scale_matrix = jnp.identity(out_dim) * sig_vector
  cov_matrix = np.matmul(scale_matrix, scale_matrix.T)
  cov_matrix = cov_matrix * sigma_temp
  sample = nrandom.multivariate_normal(mus_vector, cov_matrix, 1)
  return sample


class MDRNN(nn.Module):
    @nn.compact
    def __call__(self, carry, inputs):
      # LSTM layer 1
      carry, inputs = nn.OptimizedLSTMCell()(carry,inputs)
      # LSTM layer 2
      carry, outputs = nn.OptimizedLSTMCell()(carry,inputs)
      # Three Dense layers then predict weights, centres & scales
      mdn_mus = nn.Dense(num_mixtures*out_dim)(outputs)
      mdn_sigmas = nn.elu(nn.Dense(num_mixtures*out_dim)(outputs))
      mdn_pis = nn.Dense(num_mixtures)(outputs)
      return sample_from_output(mdn_mus, mdn_sigmas, mdn_pis)

    
    # defines shape of input?

mdrnn = MDRNN()


@jit
def init_params(rng):
  params = mdrnn.init(rng, (cell_state, hidden_state), x)['params']
  return params

# Get initial parameters
params = init_params(jax.random.PRNGKey(42))

class Empi(Program):

  _params = params
  _cell_state = cell_state
  _hidden_state = hidden_state


  def run(self, x=Program.like(x)):
    mus, sigmas, pis = self._lstm((self._cell_state,self._hidden_state), x)
    return mus, sigmas, pis

  @Program.kernel
  def _lstm(carry, inp):
    mus, sigmas, pis = mdrnn.apply({'params': params}, carry, inp)
    return mus, sigmas, pis


model = Empi()

print(Program.get_mlir_module(model))
