{
  self,
  lib,
  pkgs,
  common,
  secrets,
  ...
}:
{
  common.nginx = {
    ssl = {
      enableACME = true;
      forceSSL = true;
    };
    ssl-optional = {
      enableACME = true;
      addSSL = true;
    };
    ssl-inx = {
      useACMEHost = common.domain;
      forceSSL = true;
    };
    ssl-inx-optional = {
      useACMEHost = common.domain;
      addSSL = true;
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "infinidoge@inx.moe";
      dnsProvider = "rfc2136";
      group = "named";
      environmentFile = pkgs.writeText "acme-env.txt" ''
        RFC2136_NAMESERVER=ns1.inx.moe
      '';
      credentialFiles = {
        RFC2136_TSIG_SECRET_FILE = secrets.dns-universe;
      };
    };
    certs."inx.moe" = {
      group = "nginx";
      extraDomainNames = [
        "*.inx.moe"
        "*.internal.inx.moe"
        "*.tailnet.inx.moe"
      ];
    };
  };

  persist.directories = [
    "/var/lib/acme"
  ];

  backups.persist.extraExcludes = [
    "/var/log/nginx/*"
  ];

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  };

  age.secrets.dns-universe = lib.our.secrets.withGroup "named" "${self}/secrets/dns-universe.age";

  # Ensure named group exists
  users.groups.named = { };
}
