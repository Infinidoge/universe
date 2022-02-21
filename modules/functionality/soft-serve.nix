{ config, lib, pkgs, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.services.soft-serve;
in
{
  options.services.soft-serve = with types; {
    enable = mkBoolOpt false;

    path = mkOpt path "/srv/soft-serve";

    port = mkOpt port 23231;
    host = mkOpt str "0.0.0.0";
    key_path = mkOpt path "${cfg.path}/soft_serve_server_ed25519";
    repo_path = mkOpt path "${cfg.path}/repos";
    initial_admin_key = mkOpt (nullOr str) null;
  };

  config = mkIf cfg.enable {
    systemd.services.soft-serve = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "SSH Git server and TUI";
      environment = {
        SOFT_SERVE_PORT = toString cfg.port;
        SOFT_SERVE_HOST = cfg.host;
        SOFT_SERVE_KEY_PATH = cfg.key_path;
        SOFT_SERVE_REPO_PATH = cfg.repo_path;
        SOFT_SERVE_INITIAL_ADMIN_KEY = cfg.initial_admin_key;
      };
      script = "${pkgs.soft-serve}/bin/soft";
      serviceConfig.Type = "exec";
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
