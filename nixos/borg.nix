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
  common.borg = {
    # Borg Backup public key:
    # ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhldH579ixPRSBtTjnzWoDCNyUxUSl1BjogWN3keYBR borg@universe
    BORG_RSH = "ssh -i ${secrets.borg-ssh-key}"; # private key for automated backups
    BORG_REMOTE_PATH = "/usr/local/bin/borg1/borg1";
    BORG_PASSCOMMAND = "cat ${secrets.borg-password}";
    BORG_REPO = "rsync.net:backups/hosts";
  };

  environment.systemPackages = with pkgs; [ borgbackup ];

  environment.variables = {
    inherit (common.borg)
      BORG_REMOTE_PATH
      BORG_PASSCOMMAND
      BORG_REPO
      ;
  };

  users.groups.borg = { };

  age.secrets = {
    borg-ssh-key.rekeyFile = "${self}/secrets/borg-ssh-key.age";
    borg-password = withGroup "borg" "${self}/secrets/borg-password.age";
  };

  persist.directories = [
    "/root/.cache/borg"
  ];
}
