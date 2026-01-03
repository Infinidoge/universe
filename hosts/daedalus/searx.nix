{
  config,
  common,
  secrets,
  ...
}:
let
  cfg = config.services.searx;
  domain = common.subdomain "search";
in
{
  services.searx = {
    enable = true;
    configureUwsgi = true;
    redisCreateLocally = true;
    environmentFile = secrets."searx";
    uwsgiConfig = {
      disable-logging = true;
      socket = "/run/searx/searx.sock";
      chmod-socket = "660";
    };
    settings = {
      general = {
        instance_name = domain;
      };
      server = {
        secret_key = "@SECRET_KEY@";
        base_url = "https://${domain}";
        default_locale = "en";
        default_theme = "oscar";
      };
      outgoing = {
        useragent_suffix = "admin+search@inx.moe";
      };
      engines = [
        {
          name = "wolframalpha";
          disabled = false;
        }
      ];
    };
  };

  users.users.nginx.extraGroups = [ "searx" ];

  services.nginx.virtualHosts.${domain} = common.nginx.ssl-inx // {
    locations."/" = {
      extraConfig = ''
        include ${config.services.nginx.package}/conf/uwsgi_params;
        uwsgi_pass unix://${cfg.uwsgiConfig.socket};
      '';
    };
  };
}
