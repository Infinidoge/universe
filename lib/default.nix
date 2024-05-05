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

  # Only useful for functors
  recMap = f: list:
    if list == [ ] then f
    else recMap (f (head list)) (tail list)
  ;

  chain = {
    func = id;
    __functor = self: input:
      if (typeOf input) == "lambda"
      then self // { func = e: input (self.func e); }
      else self.func input;
  };

  spread = function: list: if list == [ ] then function else spread (function (head list)) (tail list);

  # Takes a function and makes it lazy, by consuming arguments and applying it to the inner function first
  # before calling the original function
  lazy = func: inner: {
    inherit func;
    app = inner;
    __functor = self: input:
      let app = self.app input; in
      if (typeOf app) == "lambda" then self // { inherit app; }
      else self.func app;
  };
} // (
  import ./digga.nix { inherit lib; }
) // (
  import ./hosts.nix { inherit lib; }
) // (
  import ./options.nix { inherit lib; }
))
