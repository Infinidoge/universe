# Change NixOS defaults, generally because of stateVersion gates
{ lib, ... }:
let
  inherit (lib) mkDefault mkForce;
in
{
  # Defaults to `true` for stateVersion < 23.11
  boot.swraid.enable = mkDefault false;
}
