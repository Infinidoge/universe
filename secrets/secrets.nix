{ config, lib, ... }:
with lib;
let
  # set ssh public keys here for your system and user
  systems = {
    Infini-DESKTOP = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7uX1myj9ghv7wMoL038oGDCdScdyLd7RvYdnoioSBh root@Infini-DESKTOP";
    Infini-FRAMEWORK = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF7PmPq/7e+YIVAvIcs6EOJ3pZVJhinwus6ZauJ3aVp0 root@Infini-FRAMEWORK";
    # Infini-SERVER = "";
  };
  users = {
    infinidoge = config.users.users.infinidoge.openssh.authorizedKeys.keys;
  };
  allKeys = flatten [
    (attrValues systems)
    (attrValues users)
  ];
in
{
  "secret.age".publicKeys = allKeys;
}
