final: prev:

let
  addPatches = package: patches: package.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ patches;
  });
in
{
  coreutils-doge = addPatches prev.coreutils [ ./coreutils.patch ];
}
