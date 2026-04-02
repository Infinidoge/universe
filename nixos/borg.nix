{
  self,
  lib,
  pkgs,
  common,
  secrets,
  ...
}:
let
  inherit (lib.our.secrets) withGroup;
in
{
  common.borg = rec {
    # Borg Backup public key:
    # ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhldH579ixPRSBtTjnzWoDCNyUxUSl1BjogWN3keYBR borg@universe
    BORG_RSH = "ssh -i ${secrets.borg-ssh-key}"; # private key for automated backups
    BORG_REMOTE_PATH = "/usr/local/bin/borg14/borg14";
    BORG_PASSCOMMAND = "cat ${secrets.borg-password}";
    BORG_REPO = "rsync.net:backups/hosts";

    # Centralize folders to avoid large duplicate cache
    BORG_CACHE_DIR = "/var/cache/borg";
    BORG_CONFIG_DIR = "/var/lib/borg";

    group = "borg";
    repo = BORG_REPO;
    readWritePaths = [
      BORG_CACHE_DIR
      BORG_CONFIG_DIR
    ];
  };

  environment.systemPackages = with pkgs; [ borgbackup ];

  home-manager.sharedModules = [
    {
      home.sessionVariables = {
        inherit (common.borg)
          BORG_CACHE_DIR
          BORG_CONFIG_DIR
          BORG_PASSCOMMAND
          BORG_REMOTE_PATH
          BORG_REPO
          ;
      };
    }
  ];

  users.groups.${common.borg.group} = { };

  age.secrets = {
    borg-ssh-key.rekeyFile = "${self}/secrets/borg-ssh-key.age";
    borg-password = withGroup common.borg.group "${self}/secrets/borg-password.age";
  };

  persist.directories =
    let
      mkDir = directory: {
        inherit directory;
        inherit (common.borg) group;
        mode = "770";
      };
    in
    map mkDir common.borg.readWritePaths;
}
