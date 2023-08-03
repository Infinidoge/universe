final: prev:

let
  addPatches = package: patches: package.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ patches;
  });
in
{
  coreutils-doge = addPatches prev.coreutils [ ./coreutils.patch ];

  # nitter = prev.nitter.overrideAttrs (old: {
  #   patches = (old.patches or [ ]) ++ [
  #     (final.fetchpatch {
  #       url = "https://patch-diff.githubusercontent.com/raw/zedeus/nitter/pull/830.patch";
  #       hash = "sha256-MIl22yWHAGQtcB1/B9OfbfoVhxOBIAJ3n1eT2Ko1Y3Q=";
  #     })
  #   ];
  # });
}
