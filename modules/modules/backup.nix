{ config, lib, pkgs, ... }:
# Borg Backup public key:
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhldH579ixPRSBtTjnzWoDCNyUxUSl1BjogWN3keYBR borg@universe
# This is used to connect to my rsync.net
with lib;
with lib.our;
let
  excludes = {
    "/home/infinidoge" = [
      ".cache"
      "*/cache2"
      "*/Cache"
    ];
  };

  append = root: path: (root + "/" + path);

  excludes' = concatLists
    (mapAttrsToList
      (root: map (append root))
      excludes
    );


  commonArgs = {
    environment = {
      BORG_RSH = "ssh -i ${config.secrets.borg-ssh-key}";
      BORG_REMOTE_PATH = "/usr/local/bin/borg1/borg1";
    };
    extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
    compression = "auto,zstd,3";
    doInit = true;
    persistentTimer = true;
    inhibitsSleep = true;
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat ${config.secrets.borg-password}";
    };
  };

  repo = "rsync.net:backups/hosts";
in
{
  environment.systemPackages = with pkgs; [
    borgbackup
  ];

  environment.variables = {
    inherit (commonArgs.environment) BORG_RSH BORG_REMOTE_PATH;
    BORG_REPO = repo;
    BORG_PASSCOMMAND = commonArgs.encryption.passCommand;
  };

  services.borgbackup.jobs."persist" = commonArgs // rec {
    paths = "/persist";
    inherit repo;
    exclude = map (append paths) excludes';
    startAt = "daily";
    prune.keep = {
      within = "1d"; # Keep all archives from the last day
      daily = 7;
      weekly = 4;
      monthly = -1;  # Keep at least one archive for each month
    };
  };
}
