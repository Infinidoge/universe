{
  self,
  pkgs,
  common,
  secrets,
  ...
}:
{
  common.nginx = {
    ssl = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
    };
    ssl-optional = {
      enableACME = true;
      acmeRoot = null;
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
  };

  persist.directories = [
    "/var/lib/acme"
  ];

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  };

  age.secrets.dns-universe.rekeyFile = "${self}/secrets/dns-universe.age";
  age.secrets.dns-universe.group = "named";

  # Ensure named group exists
  users.groups.named = { };
}
