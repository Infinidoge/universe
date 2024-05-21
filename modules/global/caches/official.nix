{ lib, ... }:
{
  nix.settings.substituters = lib.mkBefore [ "https://cache.nixos.org/" ];
}
