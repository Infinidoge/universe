{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
{
  users.users.root = {
    shell = pkgs.zsh;
    hashedPasswordFile = lib.mkIf config.modules.secrets.enable secrets.password-root;
    openssh.authorizedKeys.keys = import ./ssh-keys.nix;
  };

  age.secrets.password-root.rekeyFile = ./password.age;
}
