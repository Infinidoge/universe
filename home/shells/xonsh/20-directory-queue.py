from pathlib import Path

import xonsh
from xonsh.built_ins import XSH

aliases = XSH.aliases


class DirectoryQueue:
    def __init__(self, paths: list[Path]):
        self.paths = paths
        self.index = None
        self.original_directory = None
        self.original_next = None
        self.original_prev = None

    def enter(self):
        self.original_directory = Path(".").absolute()
        self.original_next = aliases.get("jn")
        self.original_prev = aliases.get("jp")

        if self.index is None:
            self.cd_to(0)

        @aliases.register
        @aliases.unthreadable
        def _jn(args):
            self.next()

        @aliases.register
        @aliases.unthreadable
        def _jp(args):
            self.prev()

        @aliases.register
        @aliases.unthreadable
        def _leave(args):
            self.exit()

    def exit(self):
        if self.original_directory is None:
            print("Cannot exit without entering first")
            return

        aliases["jn"] = self.original_next
        aliases["jp"] = self.original_prev

        _, exc, _ = xonsh.dirstack.cd([self.original])
        self.index = None
        self.original = None
        if exc is not None:
            raise RuntimeError(exc)

    def next(self):
        if self.index is None:
            print("Cannot jump forward without entering")
            return

        self.cd_to(self.index + 1)

    def prev(self):
        if self.index is None:
            print("Cannot jump backward without entering")
            return

        self.cd_to(self.index - 1)

    def cd_to(self, destination):
        if destination < 0:
            print("Nowhere left to return to")
            return
        if destination >= len(self.paths):
            print("Nowhere left to go")
            return

        _, exc, _ = xonsh.dirstack.cd([self.paths[destination]])
        if exc is not None:
            raise RuntimeError(exc)

        self.index = destination
