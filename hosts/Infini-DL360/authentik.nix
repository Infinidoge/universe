{
  config,
  common,
  secrets,
  ...
}:
let
  domain = common.subdomain "auth";
  ldap = common.subdomain "ldap";
in
{
  services.authentik = {
    enable = true;
    environmentFile = secrets.authentik;
    settings = {
      email = with common.email; {
        host = smtp.address;
        port = smtp.STARTTLS;
        username = outgoing;
        from = withSubaddress "authentik";
        use_tls = true;
        use_ssl = false;
      };
      disable_startup_analytics = true;
      cookie_domain = common.domain;
    };

    nginx = {
      enable = true;
      enableACME = true;
      host = domain;
    };
  };

  services.authentik-ldap = {
    enable = true;
    environmentFile = secrets.authentik-ldap;
  };

  networking.firewall.allowedTCPPorts = [
    3389
    6636
  ];

  security.acme.certs.${ldap} = {
    group = "nginx";
    webroot = null;
  };

  systemd.services.authentik-worker.serviceConfig.LoadCredential = [
    "${ldap}.pem:/etc/secrets/ssl/ldap.inx.moe/fullchain.pem"
    "${ldap}.key:/etc/secrets/ssl/ldap.inx.moe/key.pem"
  ];

  services.nginx.virtualHosts.${domain} = {
    acmeRoot = null;
  };
}
