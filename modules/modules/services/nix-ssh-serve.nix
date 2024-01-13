{ config, lib, ... }:
with lib;
{
  nix = {
    sshServe = {
      enable = mkDefault true;
      write = true;
      keys = config.user.openssh.authorizedKeys.keys;
    };

    settings.trusted-users = [ "nix-ssh" ];
  };
}
