{ lib, config, self, ... }: {
  users.users.root = {
    passwordFile = lib.mkIf config.modules.secrets.enable config.secrets.root-password;
    openssh.authorizedKeys.keys = import ./ssh-keys.nix;
  };

  home-manager.users.root = { ... }: {
    programs.ssh.matchBlocks = {
      "server.doge-inc.net" = {
        identityFile = "/root/.ssh/id_25519";
      };
    };
  };
}
