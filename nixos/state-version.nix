# Account for changes in stateVersion
{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  # Defaults to `true` for stateVersion < 23.11
  boot.swraid.enable = mkDefault false;
}
