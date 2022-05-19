{ config, lib, ... }:
{
  nix.settings.substituters = (if config.info.loc.home then (lib.mkOrder 300) else lib.mkAfter) [
    "ssh://server.doge-inc.net"
  ];
}
