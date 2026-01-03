{ common, secrets, ... }:

let
  domain = "freshrss.inx.moe";
in
{
  services.nginx.virtualHosts.${domain} = common.nginx.ssl-inx;

  services.freshrss = {
    enable = true;
    virtualHost = domain;
    baseUrl = "https://${domain}";
    dataDir = "/srv/freshrss";
    defaultUser = "infinidoge";
    passwordFile = secrets."freshrss";
  };
}
