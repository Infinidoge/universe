{
  config,
  common,
  inputs,
  ...
}:
let
  domain = common.subdomain "matrix";
  cfg = config.services.conduwuit;
  host = "http://localhost:${toString cfg.settings.global.port}";
in
{
  persist.directories = [ "/var/lib/private/conduwuit" ];

  services.conduwuit = {
    enable = true;
    package = inputs.conduwuit.packages.x86_64-linux.default;
    settings = {
      global = {
        allow_registration = false;
        database_backend = "rocksdb";
        server_name = common.domain;
        well_known = {
          client = "https://${domain}";
          server = "${domain}:443";
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8448 ];

  services.nginx.virtualHosts = {
    ${domain} = common.nginx.ssl // {
      locations."^~ /_matrix" = {
        proxyPass = host;
        recommendedProxySettings = false;
        extraConfig = ''
          proxy_set_header X-ForwardedFor $remote_addr;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Host $host;
          client_max_body_size 50M;
          proxy_http_version 1.1;
        '';
      };
      locations."/".return = "302 https://${common.domain}/";
      extraConfig = ''
        listen 8448 ssl http2 default_server;
        listen [::]:8448 ssl http2 default_server;
      '';
    };
    ${cfg.settings.global.server_name} = {
      locations."^~ /.well-known/matrix".proxyPass = host;
    };
  };
}
