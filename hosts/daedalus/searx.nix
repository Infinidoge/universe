{
  pkgs,
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
    inherit domain;
    configureUwsgi = true;
    configureNginx = true;
    redisCreateLocally = true;
    environmentFile = secrets."searx";
    uwsgiConfig = {
      disable-logging = true;
    };
    settings = {
      general = {
        instance_name = domain;
      };
      server = {
        secret_key = "@SECRET_KEY@";
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

  services.nginx.virtualHosts.${domain} = common.nginx.ssl-inx;
}
