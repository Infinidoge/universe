{ config, common, ... }:
let
  cfg = config.services.hedgedoc;
  domain = common.subdomain "md";
in
{
  services.hedgedoc = {
    enable = true;
    environmentFile = config.secrets."hedgedoc";
    settings = {
      inherit domain;
      protocolUseSSL = true;
      port = 4003;

      db = { dialect = "sqlite"; storage = "/srv/hedgedoc/db.sqlite"; };
      uploadsPath = "/srv/hedgedoc/uploads";

      allowFreeURL = true;
      requireFreeURLAuthentication = true;
    };
  };

  services.nginx.virtualHosts.${domain} = common.nginx.ssl // {
    locations."/" = {
      proxyPass = "http://${cfg.settings.host}:${toString cfg.settings.port}";
    };
  };

  systemd.services.hedgedoc.serviceConfig = {
    ReadWritePaths = [ "-/srv/hedgedoc" ];
  };
}
