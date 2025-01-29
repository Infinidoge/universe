{ lib }:
lib.makeExtensible (
  self:
  with lib;
  rec {
    flattenListSet = imports: (flatten (concatLists (attrValues imports)));
    flattenSetList = attrSet: (mapAttrs (name: value: flatten value) attrSet);

    # ["/home/user/" "/.screenrc"] -> ["home" "user" ".screenrc"]
    splitPath =
      paths:
      (filter (s: builtins.typeOf s == "string" && s != "") (concatMap (builtins.split "/") paths));

    # ["home" "user" ".screenrc"] -> "home/user/.screenrc"
    dirListToPath = dirList: (concatStringsSep "/" dirList);

    # ["/home/user/" "/.screenrc"] -> "/home/user/.screenrc"
    concatPaths =
      paths:
      let
        prefix = optionalString (hasPrefix "/" (head paths)) "/";
        path = dirListToPath (splitPath paths);
      in
      prefix + path;

    sanitizeName = name: replaceStrings [ "." ] [ "" ] (sanitizeDerivationName (removePrefix "/" name));

    mapGenAttrs =
      list: func: attrs:
      lib.genAttrs list (name: func (if builtins.typeOf attrs == "lambda" then attrs name else attrs));

    dirsOf =
      dir: lib.attrNames (lib.filterAttrs (file: type: type == "directory") (builtins.readDir dir));

    # Only useful for functors
    recMap = f: list: if list == [ ] then f else recMap (f (head list)) (tail list);

    chain = {
      func = id;
      __functor =
        self: input:
        if (typeOf input) == "lambda" then self // { func = e: input (self.func e); } else self.func input;
    };

    spread =
      function: list: if list == [ ] then function else spread (function (head list)) (tail list);

    isFunction = obj: (typeOf obj) == "lambda" || ((typeOf obj) == "set" && obj ? __functor);

    # Takes a function and makes it lazy, by consuming arguments and applying it to the inner function first
    # before calling the original function
    # if the inner object is not actually a function, then just calls the original function
    lazy =
      func: inner:
      if !(isFunction inner) then
        func inner
      else
        {
          inherit func;
          app = inner;
          __functor =
            self: input:
            let
              app = self.app input;
            in
            if isFunction app then self // { inherit app; } else self.func app;
        };

    toBase64 =
      text:
      let
        inherit (lib)
          sublist
          mod
          stringToCharacters
          concatMapStrings
          ;
        inherit (lib.strings) charToInt;
        inherit (builtins)
          substring
          foldl'
          genList
          elemAt
          length
          concatStringsSep
          stringLength
          ;
        lookup = stringToCharacters "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        sliceN =
          size: list: n:
          sublist (n * size) size list;
        pows = [
          (64 * 64 * 64)
          (64 * 64)
          64
          1
        ];
        intSextets = i: map (j: mod (i / j) 64) pows;
        compose =
          f: g: x:
          f (g x);
        intToChar = elemAt lookup;
        convertTripletInt = sliceInt: concatMapStrings intToChar (intSextets sliceInt);
        sliceToInt = foldl' (acc: val: acc * 256 + val) 0;
        convertTriplet = compose convertTripletInt sliceToInt;
        join = concatStringsSep "";
        convertLastSlice =
          slice:
          let
            len = length slice;
          in
          if len == 1 then
            (substring 0 2 (convertTripletInt ((sliceToInt slice) * 256 * 256))) + "=="
          else if len == 2 then
            (substring 0 3 (convertTripletInt ((sliceToInt slice) * 256))) + "="
          else
            "";
        len = stringLength text;
        nFullSlices = len / 3;
        bytes = map charToInt (stringToCharacters text);
        tripletAt = sliceN 3 bytes;
        head = genList (compose convertTriplet tripletAt) nFullSlices;
        tail = convertLastSlice (tripletAt nFullSlices);
      in
      join (head ++ [ tail ]);

    disko = import ./disko.nix { inherit lib; };
    filesystems = import ./filesystems.nix { inherit lib self; };
  }
  // (import ./digga.nix { inherit lib; })
  // (import ./hosts.nix { inherit lib; })
  // (import ./options.nix { inherit lib; })
)
