final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`

  kmscon = prev.kmscon.overrideAttrs (old: {
    version = "unstable-${final.sources.kmscon.version}";
    src = final.sources.kmscon.src;
  });

  olympus = prev.callPackage ./olympus.nix { };
}
