{ pkgs }:
{
  ears-cli = pkgs.callPackage ./ears-cli.nix { };
  hexagon = pkgs.callPackage ./hexagon.nix { };
  mcaselector = pkgs.callPackage ./mcaselector.nix { };
  mkSymlinks = pkgs.callPackage ./mk-symlinks.nix { };
  neocities = pkgs.callPackage ./neocities { };
  nix-modrinth-prefetch = pkgs.callPackage ./nix-modrinth-prefetch.nix { };
  olympus = pkgs.callPackage ./olympus.nix { };
  ponder = pkgs.callPackage ./ponder { };
  setris = pkgs.callPackage ./setris.nix { };
  sim65 = pkgs.callPackage ./sim65.nix { };
  substituteSubset = pkgs.callPackage ./substitute-subset.nix { };
  unbted = pkgs.callPackage ./unbted.nix { };
  bytecode-viewer = pkgs.callPackage ./bytecode-viewer.nix { };
}
