
from myfreecad.classes import Vector2d, Vector3d
from myfreecad.freecad_adapter import clear_parts, make_box, make_polygon, show_part

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

page_width = 5 * inch
page_length = (7 + 3/8) * inch

margin = 2
frame_backing_width = page_width + margin
frame_backing_length = page_length + margin
frame_backing_thickness = 1

command_strip_width = 15
command_strip_length = 45
command_strip_thickness = 1
wall_mount_block_width = command_strip_width
wall_mount_block_length = command_strip_length
wall_mount_block_thickness = 4
frame_mount_block_width = command_strip_width
frame_mount_block_length = 0.5 * wall_mount_block_length
frame_mount_block_thickness = wall_mount_block_thickness

wall_thickness = 2
tolerance = 0.4
frame_cover_width = frame_backing_width + 2 * wall_thickness + tolerance
frame_cover_length = frame_backing_length + 2 * wall_thickness + tolerance
frame_cover_height = wall_mount_block_thickness + command_strip_thickness

frame_cover_window_border_thickness = 10
frame_cover_window_width = frame_cover_width - \
    2 * frame_cover_window_border_thickness
frame_cover_window_length = frame_cover_length - \
    2 * frame_cover_window_border_thickness


def wall_mount_block(position=Vector3d(0, 0, 0), is_spacer=False):
    global make_box, wall_mount_block_width, wall_mount_block_length, wall_mount_block_thickness, command_strip_thickness
    return make_box(
        wall_mount_block_width, wall_mount_block_length, wall_mount_block_thickness + (command_strip_thickness if is_spacer else 0), position)


# frame_backing_plate = make_box(
#     frame_backing_width, frame_backing_length, frame_backing_thickness)
# wall_mount_block_1 = wall_mount_block(
#     Vector3d(0, 0, frame_backing_thickness))
# wall_mount_block_2 = wall_mount_block(Vector3d(
#     frame_backing_width - wall_mount_block_width, 0, frame_backing_thickness))
# wall_mount_block_3 = wall_mount_block(
#     Vector3d(0, frame_backing_length - wall_mount_block_length, frame_backing_thickness), True)
# wall_mount_block_4 = wall_mount_block(Vector3d(
#     frame_backing_width - wall_mount_block_width, frame_backing_length - wall_mount_block_length, frame_backing_thickness), True)


# frame_backing = frame_backing_plate.fuse(
#     wall_mount_block_1).fuse(wall_mount_block_2).fuse(wall_mount_block_3).fuse(wall_mount_block_4)

# show_part(frame_backing)


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
