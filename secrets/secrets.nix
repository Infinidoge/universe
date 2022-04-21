with builtins;
let
  flatten = x: if isList x then concatMap (y: flatten y) x else [ x ];

  systems = {
    Infini-DESKTOP = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7uX1myj9ghv7wMoL038oGDCdScdyLd7RvYdnoioSBh root@Infini-DESKTOP";
    Infini-FRAMEWORK = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF7PmPq/7e+YIVAvIcs6EOJ3pZVJhinwus6ZauJ3aVp0 root@Infini-FRAMEWORK";
    Infini-SERVER = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8ptHWTesaUzglq01O8OVqeAGxFhXutUZpkgPpBFqzY root@Infini-SERVER";
  };
  users = {
    infinidoge = import ../users/infinidoge/ssh-keys.nix;
  };
  allKeys = flatten [
    (attrValues systems)
    (attrValues users)
  ];
in
{
  "wireless.age".publicKeys = allKeys;
}
