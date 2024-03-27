{ config, pkgs, ... }:
let
  address = "127.0.0.1";
  port = 8096;
  jellyfin = "http://${address}:${toString port}";
in
{
  services.nginx.virtualHosts."jellyfin.inx.moe" = config.common.nginx.ssl // {
    locations."= /" = {
      return = "302 https://$host/web/";
    };

    locations."/" = {
      proxyPass = jellyfin;
    };

    locations."/socket" = {
      proxyPass = jellyfin;
      proxyWebsockets = true;
    };
  };

  services.jellyfin = {
    enable = true;
    dataDir = "/srv/jellyfin";
    openFirewall = true;
  };

  persist.directories = with config.services.jellyfin; [ dataDir cacheDir logDir ];
}
