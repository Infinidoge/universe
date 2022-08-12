final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`

  olympus = prev.callPackage ./olympus.nix { };

  frei = prev.callPackage ./frei.nix { source = final.sources.frei; };
}
