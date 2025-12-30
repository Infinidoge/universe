{
  config,
  pkgs,
  secrets,
  common,
  ...
}:
let
  cfg = config.services.garage.settings;
  baseDir = "/srv/garage";

  ssl-garage = {
    useACMEHost = "garage.inx.moe";
    forceSSL = true;
  };
in
{
  persist.directories = [
    baseDir
  ];

  age.secrets = {
    admin_token_file = {
      owner = "garage";
      rekeyFile = ./secrets/garage-admin-token.age;
      generator.script = "base64";
    };
    metrics_token_file = {
      owner = "garage";
      rekeyFile = ./secrets/garage-metrics-token.age;
      generator.script = "base64";
    };
    rpc_secret_file = {
      owner = "garage";
      rekeyFile = ./secrets/garage-rpc-secret.age;
      generator.script = "hex32";
    };
  };

  services.garage = {
    enable = true;
    package = pkgs.garage_2;

    settings = {
      data_dir = "${baseDir}/data";
      metadata_dir = "${baseDir}/meta";
      metadata_snapshots_dir = "${baseDir}/snapshots";

      db_engine = "sqlite";

      # No clustering yet, but just in case
      inherit (secrets) rpc_secret_file;
      rpc_bind_addr = "[::]:3901";
      rpc_public_addr = "127.0.0.1:3901";
      replication_factor = 1;

      s3_api = {
        s3_region = "garage";
        api_bind_addr = "127.0.0.1:3900";
        root_domain = ".s3.garage.inx.moe";
      };

      s3_web = {
        bind_addr = "127.0.0.1:3902";
        root_domain = ".web.garage.inx.moe";
        index = "index.html";
      };

      admin = {
        inherit (secrets) admin_token_file metrics_token_file;
        api_bind_addr = "[::]:3903";
      };
    };

    extraEnvironment = {
      GARAGE_LOG_TO_JOURNALD = "true";
    };
  };

  services.nginx.virtualHosts = {
    "s3.garage.inx.moe" = ssl-garage // {
      serverAliases = [ "*.s3.garage.inx.moe" ];
      locations."/" = {
        proxyPass = "http://${cfg.s3_api.api_bind_addr}";
        extraConfig = ''
          proxy_max_temp_file_size 0;
        '';
      };
    };
    "*.web.garage.inx.moe" = ssl-garage // {
      locations."/".proxyPass = "http://${cfg.s3_web.bind_addr}";
    };
    "admin.garage.inx.moe" = ssl-garage // {
      locations."/".proxyPass = "http://${cfg.admin.api_bind_addr}";
    };
  };

  security.acme.certs."garage.inx.moe" = {
    group = "nginx";
    extraDomainNames = [
      "s3.garage.inx.moe"
      "*.s3.garage.inx.moe"
      "*.web.garage.inx.moe"
      "admin.garage.inx.moe"
    ];
  };

  users.users.garage = {
    group = "garage";
    isSystemUser = true;
  };
  users.groups.garage = { };

  systemd.services.garage.serviceConfig = {
    DynamicUser = false;
    User = "garage";
    Group = "garage";
    ReadWritePaths = [ cfg.metadata_snapshots_dir ];
  };
}
