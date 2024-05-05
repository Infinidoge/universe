{ config, ... }:

let
  domain = "freshrss.inx.moe";
in
{
  services.nginx.virtualHosts.${domain} = config.common.nginx.ssl;

  services.freshrss = {
    enable = true;
    virtualHost = domain;
    baseUrl = "https://${domain}";
    dataDir = "/srv/freshrss";
    defaultUser = "infinidoge";
    passwordFile = config.secrets."freshrss";
  };
}
