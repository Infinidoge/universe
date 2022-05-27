{ config, lib, ... }:
{
  nix.settings.substituters = lib.mkIf (config.networking.hostName != "Infini-DESKTOP")
    ((if config.info.loc.home then (lib.mkOrder 300) else lib.mkAfter) [
      "ssh://infini-desktop"
    ]);
}
