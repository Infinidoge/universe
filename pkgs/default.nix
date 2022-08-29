final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`

  olympus = final.callPackage ./olympus.nix { };

  frei = final.callPackage ./frei.nix { source = final.sources.frei; };
}
