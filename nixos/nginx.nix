{
  self,
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
      dnsProvider = "cloudflare";
      environmentFile = secrets.dns-cloudflare;
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

  age.secrets.dns-cloudflare.rekeyFile = "${self}/secrets/dns-cloudflare.age";
}
