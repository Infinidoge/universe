{ lib, ... }:
{
  nix.settings.substituters = lib.mkAfter [
    "ssh://server.doge-inc.net"
  ];
}
