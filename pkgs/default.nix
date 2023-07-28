{ self, lib, ... }:
{
  perSystem = { pkgs, ... }:
    let
      allPackages = import ./all-packages.nix { inherit pkgs; };
    in
    {
      packages = lib.filterAttrs (_: v: lib.isDerivation v) allPackages;
      legacyPackages = lib.filterAttrs (_: v: !(lib.isDerivation v)) allPackages;
    };

  flake.overlays.packages = final: prev: (import ./all-packages.nix { pkgs = prev; });
}
