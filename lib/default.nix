{ lib }:
lib.makeExtensible (self:
with lib;
rec {
  flattenListSet = imports: (flatten (concatLists (attrValues imports)));
  flattenSetList = attrSet: (mapAttrs (name: value: flatten value) attrSet);

  # ["/home/user/" "/.screenrc"] -> ["home" "user" ".screenrc"]
  splitPath = paths:
    (filter
      (s: builtins.typeOf s == "string" && s != "")
      (concatMap (builtins.split "/") paths)
    );

  # ["home" "user" ".screenrc"] -> "home/user/.screenrc"
  dirListToPath = dirList: (concatStringsSep "/" dirList);

  # ["/home/user/" "/.screenrc"] -> "/home/user/.screenrc"
  concatPaths = paths:
    let
      prefix = optionalString (hasPrefix "/" (head paths)) "/";
      path = dirListToPath (splitPath paths);
    in
    prefix + path;

  sanitizeName = name:
    replaceStrings
      [ "." ] [ "" ]
      (sanitizeDerivationName (removePrefix "/" name));

  mapGenAttrs = list: func: attrs:
    lib.genAttrs list (name: func (if builtins.typeOf attrs == "lambda" then attrs name else attrs));

  dirsOf = dir: lib.attrNames (lib.filterAttrs (file: type: type == "directory") (builtins.readDir dir));
} // (
  import ./digga.nix { inherit lib; }
) // (
  import ./hosts.nix { inherit lib; }
) // (
  import ./options.nix { inherit lib; }
))
