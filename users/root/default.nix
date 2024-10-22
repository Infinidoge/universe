{ config, lib, pkgs, ... }: {
  users.users.root = {
    shell = pkgs.zsh;
    hashedPasswordFile = lib.mkIf config.modules.secrets.enable config.secrets.root-password;
    openssh.authorizedKeys.keys = import ./ssh-keys.nix;
  };

  home-manager.users.root = { ... }: { };
}
