
import jax
from iree.jax import Program
from jax.nn import relu
from jax.nn import sigmoid
from jax.nn import tanh
from jax import numpy as jnp, random, lax, jit
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


x = jnp.ones(2)
cell_state = jnp.ones((1, hidden_units))
hidden_state = jnp.ones((1, hidden_units))

params = Params(x, cell_state, hidden_state)

class MDRNN(nn.Module):

    @nn.compact
    def __call__(self, carry, inputs):
        carry, inputs = nn.OptimizedLSTMCell()(carry,inputs)
        carry, inputs = nn.OptimizedLSTMCell()(carry,inputs)
        carry, inputs = nn.OptimizedLSTMCell()(carry,inputs)

        # Three Dense layers then predict weights, centres & scales

        return nn.OptimizedLSTMCell()(carry,inputs)

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
    (self._cell_state, self._hidden_state), result = self._lstm((self._cell_state,self._hidden_state), x)
    return result

  @Program.kernel
  def _lstm(carry, inp):
    carry, out = mdrnn.apply({'params': params}, carry, inp)
    return carry, out


model = Empi()

print(Program.get_mlir_module(model))
