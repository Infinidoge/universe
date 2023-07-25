final: prev:

let
  addPatches = package: patches: package.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ patches;
  });
in
{
  coreutils-doge = addPatches prev.coreutils [ ./coreutils.patch ];

  kitty = addPatches prev.kitty [
    (final.fetchpatch {
      url = "https://github.com/kovidgoyal/kitty/commit/e50ab57b8d9c7b78d0ac106c33b44ea55ae86f0b.patch";
      hash = "sha256-S4/BWRj3cpL72Gqb0PcodmZmoIJz+faZV7kcb6X2SmI=";
    })
    (final.fetchpatch {
      url = "https://github.com/kovidgoyal/kitty/commit/601e502d2e27baca7446587cb5188c965eaf3789.patch";
      hash = "sha256-ugnjiiBWopLiAtf9KytjWEk7NH4IdVtq8Zj3GTaJLxs=";
    })
  ];

  # nitter = prev.nitter.overrideAttrs (old: {
  #   patches = (old.patches or [ ]) ++ [
  #     (final.fetchpatch {
  #       url = "https://patch-diff.githubusercontent.com/raw/zedeus/nitter/pull/830.patch";
  #       hash = "sha256-MIl22yWHAGQtcB1/B9OfbfoVhxOBIAJ3n1eT2Ko1Y3Q=";
  #     })
  #   ];
  # });
}
