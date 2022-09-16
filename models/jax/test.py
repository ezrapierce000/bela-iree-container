from iree.jax import Program
import jax.numpy as jnp
from jax import random
from collections import namedtuple
from flax import linen as nn 

key = random.PRNGKey(1)

x = random.uniform(key, (1, 1024))
b = random.uniform(key, (1, 1024))
# x = jnp.ones((1, 1024), jnp.float32) * 4.0
# b = jnp.ones((1, 1024), jnp.float32) * 8.4

Params = namedtuple("params", "x,b")

params = Params(x, b)

class Linear(Program):
    _params = params
    _x = params.x

    def get_params(self):
        return self._params

    def run(self, multiplier=Program.like(x)):
        self._x = self._linear(multiplier, self._params.x, self._params.b)
        return self._x

    def set_params(self, new_params=Program.like(params)):
        self._params = new_params

    @Program.kernel
    def _linear(m, x, b):
        return m * x + b

    @Program.kernel
    def _tanh(m):
        return jnp.maximum(0, m)

    @Program.kernel
    def _conv(m, x, b):
        nn.Conv

m = Linear()

print(Program.get_mlir_module(m))
