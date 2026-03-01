
from typing import TypeAlias

import freecad
from freecad import part as fcpart

# FreeCAD has lots of types that aren't documented together:
# > dir(FreeCAD) = [
#   'Axis',
#   'BoundBox',
#   'CoordinateSystem',
#   'Matrix',
#   'Placement',
#   'Precision',
#   'ProgressIndicator',
#   'Rotation',
#   'TypeId',
#   'UnknownProgramOption',
#   'Vector',
#   'Vector2d',
#   'AbortIOException',
#   'BadFormatError',
#   'BadGraphError',
#   'CADKernelError',
#   'ExpressionError',
#   'FreeCADAbort',
#   'FreeCADError',
#   'ParserError',
#   'PropertyError',
#   'XMLAttributeError',
#   'XMLBaseException',
#   'XMLParseException'
# ]

Vector: TypeAlias = freecad.app.Base.Vector
Vector2d: TypeAlias = freecad.app.Base.Vector2d

Vertex: TypeAlias = fcpart.Vertex
Edge: TypeAlias = fcpart.Edge
Wire: TypeAlias = fcpart.Face
Face: TypeAlias = fcpart.Face
Shell: TypeAlias = fcpart.Edge
Solid: TypeAlias = fcpart.Solid
Compsolid: TypeAlias = fcpart.CompSolid
Compound: TypeAlias = fcpart.Compound
