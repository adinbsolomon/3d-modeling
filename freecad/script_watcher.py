
import logging
import os
import time

logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
LOGGER = logging.getLogger(__name__)

def main():
    filepath = input("Enter a filepath to watch: ")
    LOGGER.info(f"Starting to watch {filepath}... ")
    file_time = 0
    while True:
      try:
        if os.stat(filepath).st_mtime != file_time:
          exec(open(filepath).read())
          file_time = os.stat(filepath).st_mtime
      except Exception as e:
        print("Script watcher terminated:", e)
      # The FreeCAD GUI freezes during waits, and it seems that threads fail
      # This repeated sleep lets the user interract with the GUI with lower latency
      for _ in range(10):
        time.sleep(0.1)

if __name__ == "__main__":
    main()