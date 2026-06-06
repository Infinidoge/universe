{ config, common, ... }:
let
  cfg = config.services.uptime-kuma.settings;
in
{
  services.uptime-kuma = {
    enable = true;
  };

  services.nginx.virtualHosts."status.inx.moe" = common.nginx.ssl-inx // {
    locations."/" = {
      proxyPass = "http://${cfg.HOST}:${cfg.PORT}";
      proxyWebsockets = true;
    };
    locations."= /".return = "301 /status";
  };

  persist.directories = [
    "/var/lib/private/uptime-kuma"
  ];
}
