{
  common,
  config,
  secrets,
  ...
}:
let
  domain = common.subdomain "pds";
  cfg = config.services.bluesky-pds;
in
{
  age.secrets = {
    PDS_JWT_SECRET = {
      rekeyFile = ./secrets/pds-jwt-secret.age;
      intermediary = true;
      generator.script = "hex";
    };
    PDS_ADMIN_PASSWORD = {
      rekeyFile = ./secrets/pds-admin-password.age;
      intermediary = true;
      generator.script = "hex";
    };
    PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX = {
      rekeyFile = ./secrets/pds-plc-rotation-key.age;
      intermediary = true;
      generator.script =
        { pkgs, lib, ... }:
        # Official key generation method
        ''
          ${lib.getExe pkgs.openssl} ecparam --name secp256k1 --genkey --noout --outform DER \
            | tail --bytes=+8 \
            | head --bytes=32 \
            | ${lib.getExe pkgs.xxd} --plain --cols 32
        '';
    };

    pds-env = {
      owner = "pds";
      group = "pds";
      generator = {
        script = "envfile";
        dependencies = {
          inherit (config.age.secrets)
            PDS_JWT_SECRET
            PDS_ADMIN_PASSWORD
            PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX
            ;
        };
      };
    };
  };

  services.bluesky-pds = {
    enable = true;
    pdsadmin.enable = true;
    environmentFiles = [ secrets.pds-env ];
    settings = {
      PDS_HOSTNAME = domain;
      PDS_PORT = 3131;
      PDS_ADMIN_EMAIL = "admin@inx.moe";
    };
  };

  services.nginx.virtualHosts.${domain} = common.nginx.ssl-inx // {
    locations."/" = {
      proxyPass = "http://localhost:${toString cfg.settings.PDS_PORT}";
      proxyWebsockets = true;
    };
  };

  persist.directories = [ cfg.settings.PDS_DATA_DIRECTORY ];
}
