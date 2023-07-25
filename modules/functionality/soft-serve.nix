{ config, lib, pkgs, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.services.soft-serve;
  mkIfNotNull = v: mkIf (v != null) v;
in
{
  options.services.soft-serve = with types; {
    enable = mkBoolOpt false;

    host = mkOpt str "";
    path = mkOpt path "/srv/soft-serve";
    initial_admin_keys = mkOpt (nullOr str) null;

    name = mkOpt (nullOr str) null;
    log_format = mkOpt (nullOr str) null;

    # TODO: Allow adding git hooks via Nix

    ssh = {
      host = mkOpt str cfg.host;
      port = mkOpt port 23231;

      public_url = mkOpt (nullOr str) null;
      key_path = mkOpt (nullOr str) null;
      client_key_path = mkOpt (nullOr str) null;
      max_timeout = mkOpt (nullOr int) null;
      idle_timeout = mkOpt (nullOr int) null;
    };

    git = {
      host = mkOpt str cfg.host;
      port = mkOpt port 9418;

      max_timeout = mkOpt (nullOr int) null;
      idle_timeout = mkOpt (nullOr int) null;
      max_connections = mkOpt (nullOr int) null;
    };

    http = {
      host = mkOpt str cfg.host;
      port = mkOpt port 23232;

      public_url = mkOpt (nullOr str) null;
      tls_key_path = mkOpt (nullOr str) null;
      tls_cert_path = mkOpt (nullOr str) null;
    };

    stats = {
      host = mkOpt str cfg.host;
      port = mkOpt port 23233;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.soft-serve = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "SSH Git server and TUI";
      environment = {
        SOFT_SERVE_DATA_PATH = cfg.path;
        SOFT_SERVE_INITIAL_ADMIN_KEYS = mkIfNotNull cfg.initial_admin_keys;

        SOFT_SERVE_SSH_LISTEN_ADDR = "${cfg.ssh.host}:${toString cfg.ssh.port}";
        SOFT_SERVE_GIT_LISTEN_ADDR = "${cfg.git.host}:${toString cfg.git.port}";
        SOFT_SERVE_HTTP_LISTEN_ADDR = "${cfg.http.host}:${toString cfg.http.port}";
        SOFT_SERVE_STATS_LISTEN_ADDR = "${cfg.stats.host}:${toString cfg.stats.port}";

        SOFT_SERVE_NAME = mkIfNotNull cfg.name;

        # TODO: Add the rest of the config override environment variables
        # TODO: Document how configuration from Nix works, potentially adding a comment to the top of any existing `config.yaml` in `path`
      };
      script = "${pkgs.soft-serve}/bin/soft serve";
      serviceConfig.Type = "exec";
    };

    networking.firewall.allowedTCPPorts = [
      cfg.ssh.port
      cfg.git.port
      cfg.http.port
      cfg.stats.port
    ];
  };
}

