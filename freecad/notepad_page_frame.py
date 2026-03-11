
from math import pi
from myfreecad.classes import Vector3d
from myfreecad.freecad_adapter import clear_parts, make_box, make_wedge, show_part
from myfreecad.geometry.triangle import Triangle

# Overview:
# 1. The frame will be in multiple parts, attach to the wall with a command strip,
#    and the page will be held in place with a small binder clip
# 2. The parts compsing the frame will be a wall mount, which attaches to the wall
#    using a command strip and will have some feature enabling attachment to the
#    rest of the frame, a backing which will attach to the mount, and a cover that
#    will help secure the page and improve the aesthetic
# 3. The mechanism connecting the frame backing to the wall will just a block sized
#    the command strip I'll be using
# 4. The mechanism connecting the cover to the backing will just be some corners
#    that hook over the back of the frame backing

clear_parts()

inch = 25.4
degrees = (pi / 180)

page_width = 5 * inch
page_length = (7 + 3/8) * inch

margin = 2
frame_backing_width = page_width + margin
frame_backing_length = page_length + margin
frame_backing_thickness = 1

command_strip_width = 15
command_strip_length = 45
command_strip_thickness = 1
mount_block_connection_angle = 15 * degrees
wall_mount_block_width = command_strip_width
wall_mount_block_length = 0.5 * command_strip_length
wall_mount_block_height = 4  # Distance from wall
wall_mount_block_angle_peak = Triangle(
    None, None, wall_mount_block_height, mount_block_connection_angle, 90, None).a  # Side length across from mount_block_connection_angle
frame_mount_block_width = command_strip_width
frame_mount_block_length = 0.5 * command_strip_length
frame_mount_block_height = wall_mount_block_height

wall_thickness = 2
tolerance = 0.4
frame_cover_width = frame_backing_width + 2 * wall_thickness + tolerance
frame_cover_length = frame_backing_length + 2 * wall_thickness + tolerance
frame_cover_height = wall_mount_block_height + command_strip_thickness

frame_cover_window_border_thickness = 10
frame_cover_window_width = frame_cover_width - \
    2 * frame_cover_window_border_thickness
frame_cover_window_length = frame_cover_length - \
    2 * frame_cover_window_border_thickness


frame_backing_plate = make_box(
    frame_backing_width, frame_backing_length, frame_backing_thickness)
frame_mount_block_1 = make_wedge(
    xmin=0,
    ymin=0,
    zmin=0,
    x2min=0,
    z2min=0,
    xmax=frame_mount_block_width,
    ymax=frame_mount_block_height,
    zmax=frame_mount_block_length,
    x2max=frame_mount_block_length - wall_mount_block_angle_peak,
    z2max=frame_mount_block_width,
    point=Vector3d(0, 0, frame_backing_thickness)).rotate(Vector3d(0, 0, 0), Vector3d(1, 0, 0), -90).translate(Vector3d(0, -1, frame_mount_block_height+frame_backing_thickness).as_freecad_vector())
frame_mount_block_2 = frame_mount_block_1.copy().translate(
    Vector3d(frame_backing_width-frame_mount_block_width, 0, 0).as_freecad_vector())
wall_mount_block_1 = make_box(
    wall_mount_block_width, wall_mount_block_length, wall_mount_block_height, Vector3d(0, frame_backing_length - wall_mount_block_length, frame_backing_thickness))
wall_mount_block_4 = wall_mount_block_1.copy().translate(Vector3d(
    frame_backing_width - wall_mount_block_width, 0, 0).as_freecad_vector())
frame_backing = frame_backing_plate.fuse(
    frame_mount_block_1).fuse(frame_mount_block_2).fuse(wall_mount_block_1).fuse(wall_mount_block_4)
show_part(frame_backing)

wall_mount_block_1 = make_wedge(
    xmin=0,
    ymin=0,
    zmin=0,
    x2min=0,
    z2min=0,
    xmax=wall_mount_block_width,
    ymax=wall_mount_block_height,
    zmax=wall_mount_block_length,
    x2max=wall_mount_block_length + wall_mount_block_angle_peak,
    z2max=wall_mount_block_width).rotate(Vector3d(0, 0, 0), Vector3d(1, 0, 0), -90).translate(Vector3d(0, 0, wall_mount_block_height+frame_backing_thickness).as_freecad_vector())
wall_mount_block_2 = wall_mount_block_1.copy().translate(
    Vector3d(wall_mount_block_width + 5, 0, 0).as_freecad_vector())
show_part(wall_mount_block_1.fuse(wall_mount_block_2))
# show_part(wall_mount_block_2)


frame_cover_positive = make_box(
    frame_cover_width, frame_cover_length, frame_cover_height)
frame_interior_negative = make_box(
    frame_backing_width, frame_backing_length, frame_cover_height - wall_thickness, Vector3d(wall_thickness, wall_thickness, wall_thickness))
frame_cover_window_negative = make_box(
    frame_cover_window_width, frame_cover_window_length, wall_thickness, Vector3d(
        0.5 * (frame_cover_width - frame_cover_window_width), 0.5 * (frame_cover_length - frame_cover_window_length), 0))
frame_cover = frame_cover_positive.cut(
    frame_interior_negative).cut(frame_cover_window_negative)
show_part(frame_cover)
