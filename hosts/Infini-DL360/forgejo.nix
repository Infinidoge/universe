{ config, ... }:
let
  cfg = config.services.forgejo;
  domain = config.common.subdomain "git";
in
{
  services.forgejo = {
    enable = true;

    user = "git";
    stateDir = "/srv/forgejo";

    database = {
      inherit (cfg) user;
      name = "git";
      type = "postgres";
    };

    lfs.enable = true;

    mailerPasswordFile = config.secrets.smtp-password;
    settings = {
      server = {
        ROOT_URL = "https://${domain}/";
        SSH_DOMAIN = config.common.domain;
        LANDING_PAGE = "explore";
      };
      mailer = with config.common.email; {
        ENABLED = true;
        PROTOCOL = "smtps";
        SMTP_ADDR = smtp.address;
        USER = outgoing;
        FROM = withSubaddress "git";
      };
      session.COOKIE_SECURE = true;
      security = {
        LOGIN_REMEMBER_DAYS = 180;
      };
      repository = {
        ENABLE_PUSH_CREATE_USER = true;
        ENABLE_PUSH_CREATE_ORG = true;
      };
      "repository.issue" = {
        MAX_PINNED = 5;
      };
      service = {
        DISABLE_REGISTRATION = true;
        OFFLINE_MODE = false;
        NO_REPLY_ADDRESS = config.common.email.outgoing;
      };
      indexer = {
        REPO_INDEXER_ENABLED = true;
      };
      "ui.meta" = {
        AUTHOR = "Infinidoge's Void";
        DESCRIPTION = "A Forgejo instance hosting Infinidoge's personal repositories";
      };
    };
  };

  services.nginx.virtualHosts.${domain} = config.common.nginx.ssl // {
    locations."/" = {
      proxyPass = "http://${cfg.settings.server.DOMAIN}:${toString cfg.settings.server.HTTP_PORT}";
      extraConfig = ''
        access_log /var/log/nginx/access.log combined if=$forgejo_access_log;
      '';
    };
  };

  services.nginx.appendHttpConfig = ''
    map $uri $forgejo_access_log {
      default 1;
      /api/actions/runner.v1.RunnerService/FetchTask 0;
    }
  '';

  users.users.${cfg.user} = {
    home = cfg.stateDir;
    useDefaultShell = true;
    group = cfg.group;
    extraGroups = [ "smtp" ];
    isSystemUser = true;
  };
}
