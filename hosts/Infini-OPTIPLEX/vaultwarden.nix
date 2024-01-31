{ config, lib, pkgs, ... }:

{
  persist.directories = [ config.services.vaultwarden-test.dataDir ];

  services.nginx.virtualHosts."bitwarden.inx.moe" = config.common.nginx.ssl // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
    };
  };

  services.vaultwarden-test = {
    enable = true;
    environmentFile = config.secrets."vaultwarden";
    dataDir = "/srv/vaultwarden";
    config = {
      DOMAIN = "https://bitwarden.inx.moe";
      SIGNUPS_ALLOWED = false;

      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";

      PUSH_ENABLED = true;
      PUSH_RELAY_URI = "https://push.bitwarden.com";

      SMTP_HOST = "smtp.purelymail.com";
      SMTP_FROM = "noreply@inx.moe";
      SMTP_PORT = 465;
      SMTP_SECURITY = "force_tls";
      SMTP_USERNAME = "noreply@inx.moe";
    };
  };
}
