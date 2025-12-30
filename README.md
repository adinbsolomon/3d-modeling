# 3d-modeling

## OpenSCAD

### OPENSCADPATH

Many of these files assume access to `common/*.scad` files, so follow the instructions in the [User Manual](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries) for use of libraries - choose the best method for your use case.

### Ideas for OpenSCAD Style

- All library functions / modules are in their own file with no others.
- Each library function / module has a (sort of) public interface that implements type checking and that call the (sort of) private interface. The private interface will have the same name but be prefixed by an underscore.
- Standardize types based on expected types of OpenSCAD built-ins, and prioritize use of these types over others.
    - Ex. the `polygon_points` type would be a list of vertices, and `polygon_points_2d` could be a specific form.
    - Implement type checking functions similar to the built-in type checking functions.
- Function style has argument type checks first (each on their own line), then argument validation (should use private functions if possible), then let statements, then logic.

## FreeCAD

**FreeCAD Python Interpreter**: This setup is pretty janky - I followed [this tutorial](https://www.reddit.com/r/FreeCAD/comments/1mknq3d/freecad_vscode_how_to_get_vs_code_to_see_freecads/) a bit to connect the FreeCAD Python interpreter up to VSCode, but I noticed that installing packages with `pip` doesn't work. I realized that an executable `python` in the same directory as the tutorial's `freecadcmd` can be used like a normal python executable with `.../python -m install ...` and installed packages are accessible from the interpreter. It seems that those installed packages are in `.../usr/lib/python3.11/site-packages/`.

**FreeCAD "Live" Updates**: I wrote a simple watcher script to run from inside the FreeCAD GUI with `exec(open(".../main.py").read())` You'll need to provide a filepath pointing to the script you want to watch and once every second the watcher script will check when the file was last modified and rerun it when an update is detected.
- Pretty janky
- Assuming this will function like the OpenSCAD editor, which is something I'm interested in, I'll probably need to create a runner class from which my FreeCAD model scripts will inherit and before creating the model each time it would destroy everything...
