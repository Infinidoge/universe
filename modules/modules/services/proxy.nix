{ config, lib, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.modules.services.proxy;
in
{
  options.modules.services.proxy = {
    enable = mkBoolOpt false;
    listen-address = mkOpt types.str "localhost:8118";
    forwards = {
      ssh = mkBoolOpt true;
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      services = {
        privoxy = {
          enable = true;

          settings = {
            enable-edit-actions = true;
            forward-socks5 = mkIf cfg.forwards.ssh "/ 127.0.0.1:49494 .";
            listen-address = cfg.listen-address;
          };
        };

        ssh-tunnel = mkIf cfg.forwards.ssh {
          enable = true;
          server = "infinidoge@server.doge-inc.net -p 245 -S none -i /home/infinidoge/.ssh/id_ed25519 -v";
          # server = "infinidoge@71.90.199.237 -p 245 -S none -i /home/infinidoge/.ssh/id_ed25519 -v";
          requiredBy = [ "privoxy.service" ];
          forwards.dynamic = [ 49494 ];
        };
      };

      networking.proxy.default = cfg.listen-address;
    })
  ];
}
