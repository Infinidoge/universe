# Repository Notes

> **Note**
> These are a set of loose guidelines, that I am using as a reminder/general format for myself.

## Commit Message Format

```
[location/scope]: [subject]

[body]

[footer]
```

### Locations

The location in a commit message represents where the change affects.

- A host (`Infini-DESKTOP`, etc.)
- A module (Just use the module name, not including `module` or `functionality` as a prefix, to reduce length)
- A profile
- `pkgs`
- `overlays`
- Etc.

If affecting multiple locations, separate with a comma.
If affecting all, use a `*`, like `hosts/*`.
If in a sub-location, separate with a slash, such as `overlays/patches`.

### Scopes

A scope is an abstract type of location, such as:

- `flake` for `flake.nix` or a flake-wide change
- `bump` for `flake.lock` updates
- `meta` for changes relating to the repository-related files (`readme.md`, `ideas.md`, `todo.md`, `repository.md`)

### Subjects

- When packaging software, location is `pkgs/package`, subject is `init at [version]` or `[version old] -> [version new]` for new packages and updates. Other changes use a normal subject
- When renaming files, use the location above the original, and use `before -> after` for the subject
