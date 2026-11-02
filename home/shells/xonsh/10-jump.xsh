import xonsh


JUMP_BASES = {
    "h": "~"
}

JUMP_EXCLUDE = [
    ".git"
]


@aliases.register
@aliases.unthreadable
def _j(args, alias_name, called_alias_name):
    # lookup jump base if called with a different name
    if called_alias_name != alias_name:
        base = called_alias_name.replace("j", "", count=1)
        if base in JUMP_BASES:
            base = JUMP_BASES[base]
        else:
            raise RuntimeError(f"Jump base '{base}' not found")

    # lookup jump base if passed as an argument
    elif args and args[0] in JUMP_BASES:
        base = JUMP_BASES[args.pop(0)]
    else:
        base = None

    base = ["--base-directory", xonsh.tools.expand_path(base)] if base else []
    excludes = []
    for exclude in JUMP_EXCLUDE:
        excludes.append("--exclude")
        excludes.append(exclude)

    # start with an initial query if there is one
    try:
        if args:
            destination = $(fd -H -t d @(base) | fzf --filepath-word -1 -q @(" ".join(args)))
        else:
            destination = $(fd -H -t d @(base) | fzf --filepath-word)
    except:
        print("Canceled")
        return

    _, exc, _ = xonsh.dirstack.cd([destination])
    if exc is not None:
        raise RuntimeError(exc)

for base in JUMP_BASES.keys():
    aliases[f"j{base}"] = "j"
