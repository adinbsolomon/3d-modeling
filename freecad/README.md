
# FreeCAD

Helpful links and notes concerning FreeCAD in Python:
- The best documentation for Parts (the module responsible for creating primitives) is [here](https://wiki.freecad.org/Part_API)
- The best documentation for handling those objects in [here](https://wiki.freecad.org/Topological_data_scripting)
- Importing a module inside `myfreecad` from another module therein requires `import myfreecad.<module>`

Actually running the python files:
- **Environment Setup**
  - PYTHONPATH includes `freecad` within this repo and [the built FreeCAD's](https://www.reddit.com/r/FreeCAD/comments/1mknq3d/freecad_vscode_how_to_get_vs_code_to_see_freecads/) `.../usr/lib`
  - Selecting [the built FreeCAD's](https://www.reddit.com/r/FreeCAD/comments/1mknq3d/freecad_vscode_how_to_get_vs_code_to_see_freecads/) `.../usr/bin/python` as the interpreter of choice permits `unittest` (`.../usr/bin/freecadcmd` doesn't)
- **Test Code**
  - Use VSCode's python interpreter functionality: CTRL+^+P; "Python: Run Python File in Terminal"
- **FreeCAD GUI LIve Updates**
  - Running `.../freecad/freecad.sh` will open the GUI, and within the GUI you can use the following commands to link a script with live updates to the UI:
  - `import script_watcher`
  - `script_watcher.watch_script`
  - Enter the relative path to your script; for example `test_script.py`
  - Make changes to your script and save to have the script executed in the GUI
  - You can stop the script watcher with CTRL+C in the python console
