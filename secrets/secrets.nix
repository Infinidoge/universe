{ lib, ... }:
with lib;
let
  # set ssh public keys here for your system and user
  systems = {
    Infini-DESKTOP = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID9a6DiYuEeA+bX4rWgWGRUZwtln8sXtxCG9fPuvp9Hx root@Infini-DESKTOP";
    Infini-FRAMEWORK = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF7PmPq/7e+YIVAvIcs6EOJ3pZVJhinwus6ZauJ3aVp0 root@Infini-FRAMEWORK";
    # Infini-RPI = "";
    # Infini-SERVER = "";
    # Infini-STICK = "";
    # Infini-SWIFT = "";
  };
  users = {
    infinidoge = "";
  };
  allKeys = flatten [
    (attrValues systems)
    (attrValues users)
  ];
in
{
  "secret.age".publicKeys = allKeys;
}
