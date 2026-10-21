{
  config,
  common,
  secrets,
  private,
  pkgs,
  ...
}:
let
  cfg = config.services.forgejo;
  domain = common.subdomain "git";
  url = "https://${domain}";

  vars = private.variables.forgejo;
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

    secrets.mailer.PASSWD = secrets.smtp-noreply;
    settings = {
      server = {
        ROOT_URL = "https://${domain}/";
        SSH_DOMAIN = common.domain;
        LANDING_PAGE = "explore";
        SSH_ENABLE_CERT_AUTH = true;
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

  services.forgejo-runner.instances = {
    local_privileged = {
      enable = true;
      runtimes.host = true;
      settings = {
        runner.labels = [
          "local:host"
        ];
        runner.capacity = 16;
        server.connections.inx = {
          inherit url;
          uuid = "8d3e4b20-2ecb-4816-b3bb-1e0b279951e1";
          token = vars.actions.user_token;
        };
      };
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
      runtimes.docker = true;
      settings = {
        runner.labels = [
          "docker:docker://gitea/runner-images:ubuntu-latest"
          "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest"
        ];
        runner.capacity = 16;
        server.connections.inx = {
          inherit url;
          uuid = "d87fcabf-a540-4a92-9d1f-fa3f0a200ec5";
          token = vars.actions.global_token;
        };
      };
    };
  };

  services.nginx.virtualHosts.${domain} = common.nginx.ssl-inx // {
    locations."/" = {
      proxyPass = "http://${cfg.settings.server.DOMAIN}:${toString cfg.settings.server.HTTP_PORT}";
      extraConfig = ''
        access_log /var/log/nginx/access.log combined if=$forgejo_access_log;
        client_max_body_size 0;
        proxy_request_buffering off;
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
