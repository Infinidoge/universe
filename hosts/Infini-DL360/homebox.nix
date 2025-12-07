{
  common,
  config,
  secrets,
  ...
}:
let
  cfg = config.services.homebox.settings;
  domain = common.subdomain "inventory";
in
{
  age.secrets = {
    HBOX_OIDC_CLIENT_SECRET = {
      rekeyFile = ./secrets/hbox-oidc-client-secret.age;
      intermediary = true;
    };

    homebox-env = {
      owner = config.services.homebox.user;
      group = config.services.homebox.group;
      generator = {
        script = "envfile";
        dependencies = {
          inherit (config.age.secrets) HBOX_OIDC_CLIENT_SECRET;
          HBOX_MAILER_PASSWORD = config.age.secrets.smtp-noreply;
        };
      };
    };
  };

  services.homebox = {
    enable = true;
    settings = {
      HBOX_OPTIONS_HOSTNAME = domain;
      HBOX_PORT = "7745";

      HBOX_OPTIONS_ALLOW_REGISTRATION = "false";
      HBOX_OPTIONS_ALLOW_LOCAL_LOGIN = "false";
      HBOX_OPTIONS_TRUST_PROXY = "true";

      HBOX_MAILER_HOST = common.email.smtp.address;
      HBOX_MAILER_PORT = toString common.email.smtp.STARTTLS;
      HBOX_MAILER_USERNAME = common.email.outgoing;
      HBOX_MAILER_FROM = common.email.withSubaddress "homebox";

      HBOX_OIDC_ENABLED = "true";
      HBOX_OIDC_BUTTON_TEXT = "Sign in with INX Central";
      HBOX_OIDC_ISSUER_URL = "https://auth.inx.moe/application/o/inventory/";
      HBOX_OIDC_CLIENT_ID = "6edmJHKse00I8CIa5DMUzbM83rGonr5bI5tpBZQp";
    };
  };

  systemd.services.homebox.serviceConfig.EnvironmentFile = [ secrets.homebox-env ];

  services.nginx.virtualHosts.${domain} = common.nginx.ssl-inx // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${cfg.HBOX_PORT}";
    };
  };

  persist.directories = [ "/var/lib/homebox" ];
}
