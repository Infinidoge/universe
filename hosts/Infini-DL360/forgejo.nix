{ config, common, secrets, pkgs, ... }:
let
  cfg = config.services.forgejo;
  domain = common.subdomain "git";
in
{
  persist.directories = [ "/var/lib/private/gitea-runner/" ];

  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;

    user = "git";
    stateDir = "/srv/forgejo";

    database = {
      inherit (cfg) user;
      name = "git";
      type = "postgres";
    };

    lfs.enable = true;

    secrets.mailer.PASSWD = secrets.smtp-password;
    settings = {
      server = {
        ROOT_URL = "https://${domain}/";
        SSH_DOMAIN = common.domain;
        LANDING_PAGE = "explore";
      };
      mailer = with common.email; {
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
        NO_REPLY_ADDRESS = common.email.outgoing;
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

  services.gitea-actions-runner.package = pkgs.forgejo-runner;
  services.gitea-actions-runner.instances = {
    local_privileged = {
      enable = true;
      name = "Local Privileged";
      url = "https://${domain}";
      token = common.forgejo.actions.user_token;
      labels = [
        "local:host"
      ];
      hostPackages = with pkgs; [
        bash
        coreutils
        curl
        gawk
        gitMinimal
        gnused
        nix
        wget
      ];
    };
    local = {
      enable = true;
      name = "Local";
      url = "https://${domain}";
      token = common.forgejo.actions.global_token;
      labels = [
        "docker:docker://gitea/runner-images:ubuntu-latest"
        "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest"
        "ubuntu-22.04:docker://gitea/runner-images:ubuntu-22.04"
        "ubuntu-20.04:docker://gitea/runner-images:ubuntu-20.04"
      ];
    };
  };

  services.nginx.virtualHosts.${domain} = common.nginx.ssl // {
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
