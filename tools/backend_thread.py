import time
import traceback
from typing import overload

from PySide6.QtCore import QThread



class BackendThread(QThread):
    def __init__(self, _backend):
        super().__init__(_backend.parent_obj)
        self._available = False
        self._backend = _backend
        self._count = 0

    def available(self) -> bool:
        return self._available

    def backend(self):
        return self._backend

    @overload
    def handle(self) -> bool:
        return True

    def clean(self):
        pass

    def run(self):
        self._available = True
        while not self._backend.stopped:
            try:
                self.handle()
            except:
                traceback.print_exc()
            self._count += 1
            time.sleep(0.01)
        self._available = False

