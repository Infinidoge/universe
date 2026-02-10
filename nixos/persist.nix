{ lib, options, ... }:
{
  imports = [
    {
      options.persist = lib.our.mkAliasOpt;
      options.storage = lib.our.mkAliasOpt;
      config.environment.persistence = {
        "/persist" = lib.mkAliasDefinitions options.persist;
        "/storage" = lib.mkAliasDefinitions options.storage;
      };
    }
  ];

  persist.hideMounts = true;

  persist.directories = [
    "/home"
    {
      directory = "/etc/nixos";
      user = "infinidoge";
    }
    {
      directory = "/etc/nixos-private";
      user = "infinidoge";
    }

    "/var/log"
    "/var/lib/nixos"
    "/var/lib/systemd"

    "/root/.ssh"
  ];

  persist.files = [ "/etc/machine-id" ];
}
