
import math
import unittest

from myfreecad import classes


class ClassesTest(unittest.TestCase):
    def test_vector3d(self):
        v1 = classes.Vector3d(1, 2, 3)
        v2 = classes.Vector3d(1, 2, 3)
        self.assertEqual(v1, v2)

    def test_vector2d(self):
        v = classes.Vector2d(1, 2)
        print(v)
        self.assertEqual(v.z, 0)
        print(v * 2)
        print(2 * v)

    def test_vector_magnitude(self):
        v = classes.Vector3d(1, 1, 1)
        self.assertEqual(v.magnitude(), math.sqrt(3))


if __name__ == "__main__":
    unittest.main()
