# 3d-modeling
My 3D modeling projects using OpenSCAD

# Ideas for OpenSCAD Style

- All library functions / modules are in their own file with no others.
- Each library function / module has a (sort of) public interface that implements type checking and that call the (sort of) private interface. The private interface will have the same name but be prefixed by an underscore.
- Standardize types based on expected types of OpenSCAD built-ins, and prioritize use of these types over others.
    - Ex. the `polygon_points` type would be a list of vertices, and `polygon_points_2d` could be a specific form.
    - Implement type checking functions similar to the built-in type checking functions.
- Function style has argument type checks first (each on their own line), then argument validation (should use private functions if possible), then let statements, then logic.
