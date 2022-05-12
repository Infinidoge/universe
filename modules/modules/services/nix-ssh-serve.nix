{ config, lib, ... }:
with lib;
{
  nix = {
    sshServe = {
      enable = mkDefault config.info.stationary;
      write = true;
      keys = config.user.openssh.authorizedKeys.keys;
    };

    settings.trusted-users = [ "nix-ssh" ];
  };
}
