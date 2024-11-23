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
    Infini-STICK = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0fWuozCHyPrkFKPcnqX1MyUAgnn2fJEpDSoD7bhDA4 root@Infini-STICK";
    Infini-SD = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8oViHNz64NG51uyll/q/hrSGwoHRgvYI3luD/IWTUT root@Infini-SD";
    Infini-DL360 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjmvE76BcPwZSjeNGzlguDQC67Yxa3uyOf5ZmVDWNys root@Infini-DL360";
    Infini-RASPBERRY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIwPqTFCztLbYFFUej42hRzzCBzG6BCZIb7zXi2cxeJp root@Infini-RASPBERRY";
    hestia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUMLnWIbl6WNZxm22uyDv5mM27hPCn8u8ZZ8EpF+O/3 root@hestia";
  };
  users = {
    infinidoge = import ../users/infinidoge/ssh-keys.nix;
    root = import ../users/root/ssh-keys.nix;
  };
  allKeys = filter isValidKey (flatten [
    (attrValues systems)
    (attrValues users)
  ]);

  generate = secrets: foldl' (a: b: a // b) { } (map (n: { ${n}.publicKeys = allKeys; }) secrets);
in
generate [
  "infinidoge-password.age"
  "root-password.age"
  "binary-cache-private-key.age"
  "vaultwarden.age"
  "freshrss.age"
  "borg-password.age"
  "borg-ssh-key.age"
  "cloudflare.age"
  "smtp-password.age"
  "hydra.age"
  "hedgedoc.age"
]
