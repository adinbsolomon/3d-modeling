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

TODO - figure out how let VSCode's Python extensions read package information about FreeCAD modules so autocomplete isn't terrible

### Getting Started

1. Download and install FreeCAD by following [this]() tutorial;
2. Use `freecad/freecad.sh` to start FreeCAD (after changing the paths based on your installation); 
3. In the Python console, run `import script_watcher` and `script_watcher.watch_script()`.
4. The given file will be watched for updates and executed when triggered. You should also be able to import modules in this repo given the arguments in (2).

### Environment Development

**FreeCAD Python Interpreter**: This setup is pretty janky - I followed [this tutorial](https://www.reddit.com/r/FreeCAD/comments/1mknq3d/freecad_vscode_how_to_get_vs_code_to_see_freecads/) a bit to connect the FreeCAD Python interpreter up to VSCode, but I noticed that installing packages with `pip` doesn't work. I realized that an executable `python` in the same directory as the tutorial's `freecadcmd` can be used like a normal python executable with `.../python -m pip install ...` and installed packages are accessible from the interpreter. It seems that those installed packages are in `.../usr/lib/python3.11/site-packages/`.

**FreeCAD "Live" Updates**: I wrote a simple watcher script to run from inside the FreeCAD GUI with `exec(open(".../main.py").read())` You'll need to provide a filepath pointing to the script you want to watch and once every second the watcher script will check when the file was last modified and rerun it when an update is detected.
- Pretty janky
- Assuming this will function like the OpenSCAD editor, which is something I'm interested in, I'll probably need to create a runner class from which my FreeCAD model scripts will inherit and before creating the model each time it would destroy everything...

I might be able to control the [FreeCADGui module's window](https://wiki.freecad.org/Embedding_FreeCAD) and underlying interpreter through the FreeCADGui and FreeCAD modules. It will require some exploration, but my idea is to have a script watcher in a background thread while the GUI occupies the main thread (for some reason QT won't accept a background thread).
