{ lib, config, self, ... }: {
  users.users.root = {
    hashedPasswordFile = lib.mkIf config.modules.secrets.enable config.secrets.root-password;
    openssh.authorizedKeys.keys = import ./ssh-keys.nix;
  };
}
