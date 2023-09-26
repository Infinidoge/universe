{ config, options, lib, ... }:
with lib;
with lib.our;
let
  cfg = config.modules.services.proxy;
in
{
  options.modules.services.proxy = {
    enable = mkBoolOpt false;
    port = mkOpt types.port 49494;
    listen-address = mkOpt types.str "localhost:8118";
    ssh-connect-string = "infinidoge@server.doge-inc.net -S none -i /home/infinidoge/.ssh/id_ed25519 -v";
  };

  config = mkIf cfg.enable {
    services = {
      privoxy = {
        enable = true;

        settings = {
          inherit (cfg) listen-address;
          enable-edit-actions = true;
          forward-socks5 = "/ 127.0.0.1:${toString cfg.port} .";
        };
      };

      ssh-tunnel = {
        enable = true;
        server = cfg.ssh-connect-string;
        requiredBy = [ "privoxy.service" ];
        forwards.dynamic = [ 49494 ];
      };
    };

    networking.proxy.default = cfg.listen-address;
  };
}
