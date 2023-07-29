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
    root = import ../users/root/ssh-keys.nix;
  };
  allKeys = flatten [
    (attrValues systems)
    (attrValues users)
  ];
in
{
  "infinidoge-password.age".publicKeys = allKeys;
  "root-password.age".publicKeys = allKeys;
  "binary-cache-private-key.age".publicKeys = allKeys;
  "inx.moe.pem.age".publicKeys = allKeys;
  "inx.moe.key.age".publicKeys = allKeys;
}
