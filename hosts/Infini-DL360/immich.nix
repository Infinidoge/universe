{ config, pkgs, common, ... }:
let
  domain = common.subdomain "photos";
  cfg = config.services.immich;
in
{
  services.nginx.virtualHosts.${domain} = common.nginx.ssl // {
    extraConfig = ''
      client_max_body_size 5000M;

      proxy_read_timeout 600s;
      proxy_send_timeout 600s;
      send_timeout 600s;
    '';
    locations."/" = {
      proxyPass = "http://${cfg.host}:${toString cfg.port}";
      proxyWebsockets = true;
    };
  };

  services.immich = {
    enable = true;
    mediaLocation = "/srv/immich";
  };
}
