{
  lib,
  config,
  common,
  ...
}:
let
  inherit (config.networking) hostName;
  cfg = config.backups.persist;

  append = root: path: (root + "/" + path);
  excludes' = lib.concatLists (lib.mapAttrsToList (root: map (append root)) cfg.excludes);

  backupTimes = {
    "artemis" = "00:00";
    "dionysus" = "01:00";
    "pluto" = "02:00";
    "apophis" = "03:00";
    "daedalus" = "04:00";
  };
in
{

  imports = [
    {
      options.backups.persist = {
        excludes = with lib.types; lib.our.mkOpt (attrsOf (listOf str)) { };
        extraExcludes = with lib.types; lib.our.mkOpt (listOf str) [ ];
      };
    }
  ];

  services.borgbackup.jobs.persist = rec {
    paths = "/persist";
    repo = common.borg.BORG_REPO;
    startAt = if backupTimes ? ${hostName} then "*-*-* ${backupTimes.${hostName}}" else [ ];
    exclude = map (append paths) (excludes' ++ cfg.extraExcludes);

    environment = {
      inherit (common.borg) BORG_RSH BORG_REMOTE_PATH;
    };
    extraCreateArgs = "--verbose --stats --checkpoint-interval 300";
    compression = "auto,zstd,3";
    doInit = true;
    persistentTimer = true;
    inhibitsSleep = true;
    encryption = {
      mode = "repokey-blake2";
      passCommand = common.borg.BORG_PASSCOMMAND;
    };
    prune.keep = {
      within = "1d";
      daily = 7;
      weekly = 4;
      monthly = -1;
    };
  };

  systemd.timers."borgbackup-job-persist".requires = [ "network-online.target" ];

  backups.persist.excludes = {
    "/home/infinidoge" = [
      ".cache"
      "*/cache2"
      "*/Cache"
      ".local/share/Steam"
      ".local/share/Trash"
    ];
    "/var/log/journal/**" = [
      "system.journal"
      "user-1000.journal"
    ];
  };

}
