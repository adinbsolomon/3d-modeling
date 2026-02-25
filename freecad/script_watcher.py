
# In your FreeCAD GUI Python Interpreter (View > Panels > Python Console):
# > exec(open("../path/to/script_watcher.py").read())

# TODO - save the model before the running the script, then delete all parts from the model (maybe save two drafts). Maybe just have this as a helper util or something, or have a script runner class?
# TODO - maybe we can reload modules by crawling through the module tree and reloading those with __file__ in this repo, or maybe we can augment the import statement to proactively add new modules to a list if they meet this condition

import os
import time
import traceback

import freecad

# Hard-coded because exec()
SCRIPT_WATCHER_DIRECTORY = "/home/adin/Documents/projects/3d-modeling/freecad"
SCRIPT_WATCHER_INTERVAL = 1.0  # Seconds
# Seconds; if too high will make GUI jittery
SCRIPT_WATCHER_REFRESH_RATE = 0.01
SCRIPT_WATCHER_KEYBOARD_INTERRUPT_TERMINATION_WINDOW = 5  # Seconds
# If this file exists then terminate loop
SCRIPT_WATCHER_TERMINATION_SIGNAL_FILEPATH = "temp.stop_script"


class ScriptWatcher:
    def __init__(self,
                 filepath,
                 refresh_rate=SCRIPT_WATCHER_INTERVAL,
                 termination_signal_filepath=SCRIPT_WATCHER_TERMINATION_SIGNAL_FILEPATH):
        self.filepath = filepath
        if self.filepath is None:
            self.filepath = self.get_filepath_from_input()
        self.filepath_modification_time = 0
        self.reresh_rate = refresh_rate
        self.termination_signal_filepath = termination_signal_filepath

    def get_filepath_from_input(self):
        filepath = input("Enter a script to watch: " +
                         os.path.join(SCRIPT_WATCHER_DIRECTORY, ""))
        if not filepath.endswith(".py"):
            filepath = filepath + ".py"
        return os.path.join(SCRIPT_WATCHER_DIRECTORY, filepath)

    def do_dialogue(self):
        print("Starting script watcher for", self.relative_filepath)
        print("\t To stop watching the script, use KeyboardInterrupt (CTRL+C) or create the file",
              self.termination_signal_filepath)
        try:
            self.do_watch_loop()
        except KeyboardInterrupt:
            pass
        print("Stopping script watcher for", self.relative_filepath)

    def do_watch_loop(self):
        self.try_to_execute_script()
        self.filepath_modification_time = self.get_script_modification_time()
        while not self.termination_signal():
            new_file_time = self.get_script_modification_time()
            if self.filepath_modification_time != new_file_time:
                self.try_to_execute_script()
                self.filepath_modification_time = new_file_time
            self.wait_refresh_time()

    def termination_signal(self):
        return os.path.isfile(os.path.join(SCRIPT_WATCHER_DIRECTORY, self.termination_signal_filepath))

    def get_script_modification_time(self):
        return os.stat(self.filepath).st_mtime

    def try_to_execute_script(self):
        try:
            exec(open(self.filepath).read())
        except Exception as e:
            print("Script execution failed with", type(e).__name__, ":", e)
            print(traceback.print_exc())

    def wait_refresh_time(self):
        for _ in range(int(self.reresh_rate / SCRIPT_WATCHER_REFRESH_RATE)):
            time.sleep(SCRIPT_WATCHER_REFRESH_RATE)

    @property
    def relative_filepath(self):
        return self.filepath.replace(
            os.path.join(SCRIPT_WATCHER_DIRECTORY, ""),
            ""
        )


SCRIPT_WATCHER = None


def watch_script(filepath=None):
    global SCRIPT_WATCHER
    if filepath is not None:
        filepath = os.path.join(SCRIPT_WATCHER_DIRECTORY, filepath)
    if SCRIPT_WATCHER is None or (filepath and SCRIPT_WATCHER.filepath != filepath):
        SCRIPT_WATCHER = ScriptWatcher(filepath)
    SCRIPT_WATCHER.do_dialogue()
    print("\tTo restart ScriptWatcher, use `watch_script(<optional_relative_filepath>)`")


watch_script()
