{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.jellyfin;
in
{
  disabledModules = [ "services/misc/jellyfin.nix" ];

  options = {
    services.jellyfin = {
      enable = mkEnableOption (lib.mdDoc "Jellyfin Media Server");

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/jellyfin";
      };

      cacheDir = mkOption {
        type = types.str;
        default = "/var/cache/jellyfin";
      };

      logDir = mkOption {
        type = types.str;
        default = "/var/lib/jellyfin";
      };

      user = mkOption {
        type = types.str;
        default = "jellyfin";
        description = lib.mdDoc "User account under which Jellyfin runs.";
      };

      package = mkPackageOption pkgs "jellyfin" { };

      group = mkOption {
        type = types.str;
        default = "jellyfin";
        description = lib.mdDoc "Group under which jellyfin runs.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Open the default ports in the firewall for the media server. The
          HTTP/HTTPS ports can be changed in the Web UI, so this option should
          only be used if they are unchanged.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.settings."10-jellyfin" = {
      ${cfg.dataDir}.d = { inherit (cfg) user group; mode = "0700"; };
      ${cfg.cacheDir}.d = { inherit (cfg) user group; mode = "0700"; };
      ${cfg.logDir}.d = { inherit (cfg) user group; mode = "0700"; };
    };

    systemd.services.jellyfin = {
      description = "Jellyfin Media Server";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      # This is mostly follows: https://github.com/jellyfin/jellyfin/blob/master/fedora/jellyfin.service
      # Upstream also disable some hardenings when running in LXC, we do the same with the isContainer option
      serviceConfig = rec {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        UMask = "0077";
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${cfg.package}/bin/jellyfin --datadir '${cfg.dataDir}' --cachedir '${cfg.cacheDir}' --logdir '${cfg.logDir}'";
        Restart = "on-failure";
        TimeoutSec = 15;
        SuccessExitStatus = [ "0" "143" ];

        # Security options:
        NoNewPrivileges = true;
        SystemCallArchitectures = "native";
        # AF_NETLINK needed because Jellyfin monitors the network connection
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
        RestrictNamespaces = !config.boot.isContainer;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        ProtectControlGroups = !config.boot.isContainer;
        ProtectHostname = true;
        ProtectKernelLogs = !config.boot.isContainer;
        ProtectKernelModules = !config.boot.isContainer;
        ProtectKernelTunables = !config.boot.isContainer;
        LockPersonality = true;
        PrivateTmp = !config.boot.isContainer;
        # needed for hardware acceleration
        PrivateDevices = false;
        PrivateUsers = true;
        RemoveIPC = true;

        SystemCallFilter = [
          "~@clock"
          "~@aio"
          "~@chown"
          "~@cpu-emulation"
          "~@debug"
          "~@keyring"
          "~@memlock"
          "~@module"
          "~@mount"
          "~@obsolete"
          "~@privileged"
          "~@raw-io"
          "~@reboot"
          "~@setuid"
          "~@swap"
        ];
        SystemCallErrorNumber = "EPERM";
      };
    };

    users.users = mkIf (cfg.user == "jellyfin") {
      jellyfin = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "jellyfin") {
      jellyfin = { };
    };

    networking.firewall = mkIf cfg.openFirewall {
      # from https://jellyfin.org/docs/general/networking/index.html
      allowedTCPPorts = [ 8096 8920 ];
      allowedUDPPorts = [ 1900 7359 ];
    };

  };

  meta.maintainers = with lib.maintainers; [ minijackson ];
}
