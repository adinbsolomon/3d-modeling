
import freecad
from freecad import part as fcpart

from myfreecad.classes import Number, Vector3d, Vector2dList
from myfreecad.freecad_types import Solid, Wire


def clear_parts():
    camera_view = None
    doc = freecad.app.activeDocument()
    if doc:
        camera_view = freecad.gui.activeView().getCamera()
        freecad.app.closeDocument(doc.Name)
    new_doc = freecad.app.newDocument()
    if camera_view is not None:
        freecad.gui.activeView().setCamera(camera_view)
    return new_doc


def show_part(part):
    fcpart.show(part)


# Based on https://wiki.freecad.org/Part_API
_default_point = Vector3d(0, 0, 0)
_default_direction = Vector3d(0, 0, 1)


def make_box(
        length: Number, width: Number, height: Number, point: Vector3d = _default_point, direction: Vector3d = _default_direction):
    return fcpart.makeBox(
        length, width, height, point.as_freecad_vector(), direction.as_freecad_vector())


def make_polygon(polygon: Vector2dList) -> Wire:
    return fcpart.makePolygon(
        [v.as_freecad_vector() for v in polygon])


def make_wedge(
        xmin: Number,
        ymin: Number,
        zmin: Number,
        x2min: Number,
        z2min: Number,
        xmax: Number,
        ymax: Number,
        zmax: Number,
        x2max: Number,
        z2max: Number,
        point: Vector3d = _default_point, direction: Vector3d = _default_direction
) -> Solid:  # TODO - verify this return type
    return fcpart.makeWedge(xmin, ymin, zmin, x2min, z2min, xmax, ymax, zmax, x2max, z2max, point.as_freecad_vector(), direction.as_freecad_vector())
