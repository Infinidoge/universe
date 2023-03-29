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
      (strings.sanitizeDerivationName (removePrefix "/" name));
})
