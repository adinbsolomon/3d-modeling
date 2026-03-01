
import abc
import math
import typing

import freecad

from myfreecad.freecad_types import Vector as fcVector, Vector2d as fcVector2d

Number: typing.TypeAlias = typing.Union[int, float]


class Vector(abc.ABC):
    @classmethod
    def create_vector(cls, values: typing.List[Number]):
        obj = super().__new__(cls)
        obj.values = values
        return obj

    def magnitude(self) -> float:
        return math.sqrt(sum([n ** 2 for n in self.values]))

    def as_unit(self) -> "Vector":
        divisor = self.magnitude() or 1
        return self._do_unary_op(lambda n: n / divisor)

    def dot_product(self, other: "Vector") -> Number:
        if len(self) != len(other):
            raise ValueError(
                f"Vectors need to be of the same length: {self=}, {other=}")
        return sum([a+b for (a, b) in zip(self, other)])

    def __str__(self) -> str:
        return f"Vector{len(self)}d({self.values})"

    def __repr__(self) -> str:
        return str(self.values)

    def __bytes__(self) -> bytes:
        return bytes(self.values)

    def __format__(self) -> str:
        return format(self.values)

    def __len__(self) -> int:
        return len(self.values)

    def __getitem__(self, index: int) -> Number:
        return self.values[index]

    def __setitem__(self, index: int, new: Number) -> None:
        self.values[index] = new

    def __iter__(self):
        raise NotImplementedError()

    def __next__(self):
        raise NotImplementedError()

    def __contains__(self, n: Number) -> bool:
        return n in self.values

    def __eq__(self, other: "Vector") -> bool:
        return len(self) == len(other) and False not in [self[i] == other[i] for i in range(len(self))]

    def __ne__(self, other: "Vector") -> bool:
        return not (self == other)

    def _do_unary_op(self, op: typing.Callable[[Number], Number], in_place: bool = False) -> "Vector":
        if in_place:
            for i in range(len(self)):
                self[i] = op(self[i])
            return self
        resulting_values = [op(n) for n in self.values]
        return self.__class__.create_vector(resulting_values)

    def _do_binary_op(self, other: "Vector", op: typing.Callable[[Number, Number], Number], in_place: bool = False) -> "Vector":
        if len(self) != len(other):
            raise ValueError(len(self), len(other))
        if in_place:
            for i in range(len(self)):
                self[i] = op(self[i], other[i])
            return self
        resulting_values = [op(self[i], other[i]) for i in range(len(self))]
        return self.__class__.create_vector(resulting_values)

    def __add__(self, other: typing.Union["Vector", Number]) -> "Vector":
        if isinstance(other, Vector):
            return self._do_binary_op(other, lambda a, b: a + b)
        return self._do_unary_op(lambda n: n + other)

    def __radd__(self, other: typing.Union["Vector", Number]) -> "Vector":
        return self.__add__(other)

    def __sub__(self, other: typing.Union["Vector", Number]) -> "Vector":
        if isinstance(other, Vector):
            return self._do_binary_op(other, lambda a, b: a - b)
        return self._do_unary_op(lambda n: n - other)

    def __rsub__(self, other: typing.Union["Vector", Number]) -> "Vector":
        return self.__sub__(other)

    def __mul__(self, other: typing.Union["Vector", Number]) -> "Vector":
        if isinstance(other, Vector):
            return self._do_binary_op(other, lambda a, b: a * b)
        return self._do_unary_op(lambda n: n * other)

    def __rmul__(self, other: typing.Union["Vector", Number]) -> "Vector":
        return self.__mul__(other)

    def __truediv__(self, other: typing.Union["Vector", Number]) -> "Vector":
        if isinstance(other, Vector):
            return self._do_binary_op(other, lambda a, b: a / b)
        return self._do_unary_op(lambda n: n / other)

    def __rtruediv__(self, other: typing.Union["Vector", Number]) -> "Vector":
        return self.__truediv__(other)

    def __floordiv__(self, other: typing.Union["Vector", Number]) -> "Vector":
        if isinstance(other, Vector):
            return self._do_binary_op(other, lambda a, b: a // b)
        return self._do_unary_op(lambda n: n // other)

    def __mod__(self, other: typing.Union["Vector", Number]) -> "Vector":
        if isinstance(other, Vector):
            return self._do_binary_op(other, lambda a, b: a % b)
        return self._do_unary_op(lambda n: n % other)

    def __pow__(self, other: typing.Union["Vector", Number]) -> "Vector":
        if isinstance(other, Vector):
            return self._do_binary_op(other, lambda a, b: a ^ b)
        return self._do_unary_op(lambda n: n ^ other)

    def __iadd__(self, other: typing.Union["Vector", Number]) -> "Vector":
        if isinstance(other, Vector):
            return self._do_binary_op(other, lambda a, b: a + b, in_place=True)
        return self._do_unary_op(lambda n: n + other, in_place=True)

    def __neg__(self) -> "Vector":
        return self._do_unary_op(lambda n: -n)

    def __abs__(self) -> "Vector":
        return self._do_unary_op(lambda n: abs(n))

# Vector2d is Vector3d with z=0


class Vector3d(Vector):
    def __new__(cls, x: Number, y: Number, z: Number):
        return super().create_vector([x, y, z])

    def as_freecad_vector(self) -> fcVector:
        return fcVector(self.x, self.y, self.z)

    @property
    def x(self):
        return self[0]

    @property
    def y(self):
        return self[1]

    @property
    def z(self):
        return self[2]

    @x.setter
    def x(self, new: Number):
        self.values[0] = new

    @y.setter
    def y(self, new: Number):
        self.values[1] = new

    @z.setter
    def z(self, new: Number):
        self.values[2] = new

# Vector2d is Vector3d with z=0


class Vector2d(Vector3d):
    def __new__(cls, x: Number, y: Number):
        return super().__new__(cls, x, y, z=0)

    def as_freecad_vector2d(self) -> fcVector2d:
        return fcVector2d(self.x, self.y)


# Vector2d is Vector3d with z=0
Vector3dList: typing.TypeAlias = typing.List[Vector3d]
# Vector2d is Vector3d with z=0
Vector2dList: typing.TypeAlias = typing.List[Vector2d]
