{ config, common, ... }:

let
  domain = "freshrss.inx.moe";
in
{
  services.nginx.virtualHosts.${domain} = common.nginx.ssl;

  services.freshrss = {
    enable = true;
    virtualHost = domain;
    baseUrl = "https://${domain}";
    dataDir = "/srv/freshrss";
    defaultUser = "infinidoge";
    passwordFile = config.secrets."freshrss";
  };
}
