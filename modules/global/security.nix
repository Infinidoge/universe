{ config, lib, ... }:
with lib;
{
  # Security settings based on https://github.com/hlissner/dotfiles/blob/master/modules/security.nix
  security = {
    sudo.extraConfig = ''
      Defaults lecture=never
    '';
    acme.acceptTerms = true;

    pam.enableSSHAgentAuth = true;
  };

  boot = {
    # Make tmp volatile, using tmpfs is speedy on SSD systems
    # Redundant on opt-in state systems
    # tmpOnTmpfs = mkDefault true;
    # cleanTmpDir = mkDefault (!config.boot.tmpOnTmpfs);
  };

  # Allow non-root users to allow other users to access mount point
  programs.fuse.userAllowOther = mkDefault true;

  # For rage encryption, all hosts need a ssh key pair
  services.openssh = {
    enable = true;
    openFirewall = mkDefault true;
    forwardX11 = mkDefault false;
    hostKeys = mkDefault [
      {
        bits = 4096;
        openSSHFormat = true;
        path = "/etc/ssh/ssh_host_rsa_key";
        rounds = 100;
        type = "rsa";
      }
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        rounds = 100;
        type = "ed25519";
      }
    ];
  };
}
