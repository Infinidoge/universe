{
  config,
  common,
  secrets,
  lib,
  pkgs,
  ...
}:
let
  domain = common.subdomain "bitwarden";
in
{
  persist.directories = [ config.services.vaultwarden.dataDir ];

  services.nginx.virtualHosts.${domain} = common.nginx.ssl-inx // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
    };
  };

  services.vaultwarden = {
    enable = true;
    environmentFile = secrets."vaultwarden";
    dataDir = "/srv/vaultwarden";
    config = with common.email; {
      DOMAIN = "https://${domain}";
      SIGNUPS_ALLOWED = false;

      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";

      PUSH_ENABLED = true;
      PUSH_RELAY_URI = "https://push.bitwarden.com";

      SMTP_HOST = smtp.address;
      SMTP_PORT = smtp.SSLTLS;
      SMTP_SECURITY = "force_tls";
      SMTP_USERNAME = outgoing;
      SMTP_FROM = withSubaddress "vaultwarden";
    };
  };
}
