{
  pkgs,
  common,
  secrets,
  inputs,
  ...
}:
let
  domain = common.subdomain "auth";
  ldap = common.subdomain "ldap";

  authentikScope = (inputs.authentik-nix.lib.mkAuthentikScope { inherit pkgs; }).overrideScope (
    final: prev: {
      authentikComponents = prev.authentikComponents // {
        docs = prev.authentikComponents.docs.overrideAttrs {
          dontCheckForBrokenSymlinks = true;
        };
      };
    }
  );
in
{
  services.authentik = {
    enable = true;
    inherit (authentikScope) authentikComponents;
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
    3389 # <- 389 port forwarded, LDAP
    6636 # <- 636 port forwarded, LDAPS
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
