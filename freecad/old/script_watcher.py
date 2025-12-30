
import logging
import os

from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer

LOGGER = logging.getLogger(__name__)

class Watcher:
  def __init__(self, filepath):
    assert filepath.endswith(".py"), "File should be a Python script (.py)"
    assert os.path.isfile(filepath), "This filepath doesn't point to a file"
    self.filepath = filepath
    self.event_handler = ScriptHandler(self.filepath)
    self.observers = {
      os.path.dirname(self.filepath): self.create_observer(os.path.dirname(self.filepath))
    }
  def start(self):
    LOGGER.info(f"Starting Watcher for {self.filepath}:")
    for filepath, observer in self.observers.items():
      LOGGER.info(f"\tStarting observer for {filepath}...")
      observer.start()
  def stop(self):
    LOGGER.info(f"Stopping Watcher for {self.filepath}:")
    for filepath, observer in self.observers.items():
      LOGGER.info(f"\tStopping observer for {filepath}...")
      try:
        while observer.is_alive():
          observer.join(1)
      finally:
        observer.stop()
        observer.join()
  def create_observer(self, filepath):
    observer = Observer()
    observer.schedule(self.event_handler, filepath, recursive=os.path.isdir(filepath))
    return observer

class ScriptHandler(FileSystemEventHandler):
  def __init__(self, filepath):
    super().__init__()
    self.filepath = filepath
  def on_any_event(self, event):
      LOGGER.debug(f"Event detected: {event}")
