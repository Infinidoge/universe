final: prev: {
  coreutils-doge = prev.coreutils.overrideAttrs (old: {
    patches = [ ./coreutils.patch ];
  });
}
