{ pkgs }:
{
  ears-cli = pkgs.callPackage ./ears-cli.nix { };
  fw-ectool = pkgs.callPackage ./fw-ectool.nix { };
  hexagon = pkgs.callPackage ./hexagon.nix { };
  mcaselector = pkgs.callPackage ./mcaselector.nix { };
  nix-modrinth-prefetch = pkgs.callPackage ./nix-modrinth-prefetch.nix { };
  olympus = pkgs.callPackage ./olympus.nix { };
  sim65 = pkgs.callPackage ./sim65.nix { };
  substituteSubset = pkgs.callPackage ./substitute-subset.nix { };
  unbted = pkgs.callPackage ./unbted.nix { };
  bytecode-viewer = pkgs.callPackage ./bytecode-viewer.nix { };
  unmap = pkgs.callPackage ./unmap.nix { };
  tmx-cups-ppd = pkgs.callPackage ./tmx-cups-ppd.nix { };
}
