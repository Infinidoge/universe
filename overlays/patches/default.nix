final: prev: {
  coreutils-doge = prev.coreutils.overrideAttrs (old: {
    patches = old.patches ++ [ ./coreutils.patch ];
  });
}
