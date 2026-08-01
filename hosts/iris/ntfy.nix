{
  common,
  secrets,
  config,
  ...
}:
let
  cfg = config.services.ntfy-sh;
  domain = common.subdomain "notify";
in
{
  age.secrets = {
    ntfy-webpush-keys = {
      generator.script =
        # Uses bash file descriptor trickory to output the yaml to stdout
        # https://stackoverflow.com/questions/2342826/how-can-i-pipe-stderr-and-not-stdout
        { pkgs, lib, ... }: "${lib.getExe pkgs.ntfy-sh} webpush keys -f /dev/stderr 2>&1 > /dev/null";

      intermediary = true;
    };

    NTFY_WEB_PUSH_PUBLIC_KEY = {
      generator = {
        script = "yaml-query";
        dependencies.input = config.age.secrets.ntfy-webpush-keys;
      };
      settings.query = ''."web-push-public-key"'';
      intermediary = true;
    };

    NTFY_WEB_PUSH_PRIVATE_KEY = {
      generator = {
        script = "yaml-query";
        dependencies.input = config.age.secrets.ntfy-webpush-keys;
      };
      settings.query = ''."web-push-private-key"'';
      intermediary = true;
    };

    ntfy-env = {
      owner = cfg.user;
      group = cfg.group;
      generator = {
        script = "envfile";
        dependencies = {
          NTFY_SMTP_SENDER_PASS = config.age.secrets.smtp-noreply;
          inherit (config.age.secrets)
            NTFY_WEB_PUSH_PUBLIC_KEY
            NTFY_WEB_PUSH_PRIVATE_KEY
            ;
        };
      };
    };
  };

  services.ntfy-sh = {
    enable = true;
    environmentFile = secrets.ntfy-env;
    settings = {
      base-url = "https://${domain}";
      behind-proxy = true;
      proxy-trusted-hosts = "127.0.0.1";

      attachment-expiry-duration = "24h";
      message-delay-limit = "14d";

      smtp-sender-addr = with common.email.smtp; "${address}:${toString STARTTLS}";
      smtp-sender-user = common.email.outgoing;
      smtp-sender-from = common.email.withSubaddress "ntfy";
      smtp-sender-verify = true;

      smtp-server-listen = ":25";
      smtp-server-domain = domain;
      smtp-server-addr-prefix = ""; # Not worried about spam on separate domain

      web-push-file = "/var/lib/ntfy-sh/web-push.db";
      web-push-email-address = "admin@inx.moe";

      enable-login = true;
      require-login = true;
      enable-reservations = true;

      auth-default-access = "deny-all";
      auth-access = [
        "*:up*:write-only" # UnifiedPush
      ];
    };
  };

  services.nginx.virtualHosts.${domain} = common.nginx.ssl-inx // {
    locations."/" = {
      proxyPass = "http://${cfg.settings.listen-http}";
      proxyWebsockets = true;
    };
  };
}
