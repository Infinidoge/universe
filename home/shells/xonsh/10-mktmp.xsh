class TempDir:
    def __init__(self, args, default="tmp"):
        self.dirspec = ".".join(args) or default
        if self.dirspec.count("X") < 3:
            self.dirspec += ".XXX"

        self.dir = None

    def __enter__(self):
        self.dir = $(mktemp -t -d @(self.dirspec))
        return self.dir

    def __exit__(self, _type, _value, _traceback):
        # TODO: Remove directory if an exception occurs
        _, exc, _ = @.imp.xonsh.dirstack.cd([self.dir])
        if exc is not None:
            raise RuntimeError(exc)

    def enter(self):
        with self:
            pass


@aliases.register
@aliases.unthreadable
def _mktmp(args):
    TempDir(args).enter()

@aliases.register
@aliases.unthreadable
def _mktmpunzip(args):
    if len(args) < 1:
        raise RuntimeError("Missing file to unzip")

    file = @.imp.pathlib.Path(args[0])
    if not file.exists():
        raise RuntimeError("File does not exist")

    with TempDir(args[1:2], default="unzip") as d:
        unzip @(file) @(args[2:]) -d @(d)
        mv @(file) @(d)

@aliases.register
@aliases.unthreadable
def _mktmpclone(args):
    if len(args) < 1:
        raise RuntimeError("Missing location to clone")

    with TempDir(args[1:2], default="clone") as d:
        git clone @(args[0]) @(d) @(args[2:])
