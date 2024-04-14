with builtins;
let
  flatten = x: if isList x then concatMap (y: flatten y) x else [ x ];
  hasPrefix = pref: str: (substring 0 (stringLength pref) str == pref);
  isValidKey = key: all (keyPrefix: !(hasPrefix keyPrefix key)) [
    "sk-ssh-ed25519"
  ];

  systems = {
    Infini-DESKTOP = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7uX1myj9ghv7wMoL038oGDCdScdyLd7RvYdnoioSBh root@Infini-DESKTOP";
    Infini-FRAMEWORK = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF7PmPq/7e+YIVAvIcs6EOJ3pZVJhinwus6ZauJ3aVp0 root@Infini-FRAMEWORK";
    Infini-SERVER = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8ptHWTesaUzglq01O8OVqeAGxFhXutUZpkgPpBFqzY root@Infini-SERVER";
    Infini-OPTIPLEX = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG8fY684SPKeOUsJqaV6LJwwztWxztaU9nAHPBxBtyU root@Infini-OPTIPLEX";
    Infini-STICK = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCg81G/oysjFkHXo1E9XPGoULpv9rR0HyWoR2wIcl6C root@Infini-STICK";
    Infini-SD = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8oViHNz64NG51uyll/q/hrSGwoHRgvYI3luD/IWTUT root@Infini-SD";
  };
  users = {
    infinidoge = import ../users/infinidoge/ssh-keys.nix;
    root = import ../users/root/ssh-keys.nix;
  };
  allKeys = filter isValidKey (flatten [
    (attrValues systems)
    (attrValues users)
  ]);
in
{
  "infinidoge-password.age".publicKeys = allKeys;
  "root-password.age".publicKeys = allKeys;
  "binary-cache-private-key.age".publicKeys = allKeys;
  "inx.moe.pem.age".publicKeys = allKeys;
  "inx.moe.key.age".publicKeys = allKeys;
  "vaultwarden.age".publicKeys = allKeys;
  "freshrss.age".publicKeys = allKeys;
  "borg-password.age".publicKeys = allKeys;
  "borg-ssh-key.age".publicKeys = allKeys;
}
