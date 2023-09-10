
module maybe_3d(height=undef) {
    if (is_undef(height)) {
        children();
    } else {
        linear_extrude(height=height) children();
    }
}