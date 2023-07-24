final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`

  hexagon = final.callPackage ./hexagon.nix { };
  mcaselector = final.callPackage ./mcaselector.nix { };
  nix-modrinth-prefetch = final.callPackage ./nix-modrinth-prefetch.nix { };
  olympus = final.callPackage ./olympus.nix { };
  qtile-unstable = final.callPackage ./qtile.nix { source = final.sources.qtile; };
  setris = final.callPackage ./setris.nix { };
  sim65 = final.callPackage ./sim65.nix { };
  substituteSubset = final.callPackage ./substitute-subset.nix { };
  unbted = final.callPackage ./unbted.nix { };
}
