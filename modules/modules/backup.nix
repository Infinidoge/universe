{ config, lib, pkgs, ... }:
# Borg Backup public key:
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhldH579ixPRSBtTjnzWoDCNyUxUSl1BjogWN3keYBR borg@universe
# This is used to connect to my rsync.net
with lib;
with lib.our;
let
  append = root: path: (root + "/" + path);

  excludes' = concatLists
    (mapAttrsToList
      (root: map (append root))
      cfg.excludes
    );

  commonArgs = {
    environment = {
      BORG_RSH = "ssh -i ${config.secrets.borg-ssh-key}";
      BORG_REMOTE_PATH = "/usr/local/bin/borg1/borg1";
      BORG_RELOCATED_REPO_ACCESS_IS_OK = "yes";
    };
    extraCreateArgs = "--verbose --stats --checkpoint-interval 300";
    compression = "auto,zstd,3";
    doInit = true;
    persistentTimer = true;
    inhibitsSleep = true;
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat ${config.secrets.borg-password}";
    };
    prune.keep = {
      within = "1d"; # Keep all archives from the last day
      daily = 7;
      weekly = 4;
      monthly = -1;  # Keep at least one archive for each month
    };
  };

  mkJob = paths: commonArgs // {
    inherit paths;
    inherit (cfg) repo;
    exclude = map (append paths) (excludes' ++ cfg.extraExcludes);
    startAt = "*-*-* ${cfg.backupTimes.${config.networking.hostName}}";
  };

  cfg = config.modules.backups;
in
{
  options.modules.backups = with types; {
    enable = mkBoolOpt true;
    userEnvironment = mkBoolOpt true;
    repo = mkOpt str "rsync.net:backups/hosts";
    excludes = mkOpt (attrsOf (listOf str)) {};
    extraExcludes = mkOpt (listOf str) [ ];
    backupTimes = mkOpt (attrsOf str) { };
    jobs = mkOpt (attrsOf str) { };
  };

  config = mkMerge [
    {
      modules.backups.excludes = {
        "/home/infinidoge" = [
          ".cache"
          "*/cache2"
          "*/Cache"
          ".local/share/Steam"
        ];
      };

      modules.backups.backupTimes = {
        "Infini-FRAMEWORK" = "00:00";
        "Infini-OPTIPLEX" = "01:00";
        "Infini-SERVER" = "02:00";
        "Infini-DESKTOP" = "03:00";
        "Infini-SD" = "04:00";
      };

      modules.backups.jobs = {
        "persist" = "/persist";
      };

      common.backups = {
        inherit commonArgs;
      };

      # For allowing user access to borg password
      # See secrets/default.nix
      users.groups."borg" = { };
    }
    (mkIf cfg.userEnvironment {
      environment.systemPackages = with pkgs; [
        borgbackup
      ];

      environment.variables = {
        inherit (commonArgs.environment) BORG_RSH BORG_REMOTE_PATH;
        BORG_REPO = cfg.repo;
        BORG_PASSCOMMAND = commonArgs.encryption.passCommand;
      };
    })
    (mkIf cfg.enable {
      services.borgbackup.jobs = mapAttrs (_: mkJob) cfg.jobs;

      systemd.timers = lib.mapAttrs'
        (n: _: lib.nameValuePair "borgbackup-job-${n}" {
          requires = [ "network-online.target" ];
        })
        cfg.jobs;

      persist.directories = [
        "/root/.cache/borg"
      ];
    })
  ];
}
