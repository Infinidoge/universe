final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`

  olympus = final.callPackage ./olympus.nix { };

  nix-modrinth-prefetch = final.callPackage ./nix-modrinth-prefetch.nix { };

  qtile-unstable = final.callPackage ./qtile.nix { source = final.sources.qtile; };

  mcaselector = final.callPackage ./mcaselector.nix { };

  sim65 = final.callPackage ./sim65.nix { };
}
