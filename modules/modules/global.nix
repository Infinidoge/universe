{ config, pkgs, lib, ... }:
with lib;
with lib.hlissner;
{
  # Security settings based on https://github.com/hlissner/dotfiles/blob/master/modules/security.nix
  security = {
    sudo.extraConfig = ''
      Defaults lecture=never
    '';
    acme.acceptTerms = true;

    pam = {
      enableSSHAgentAuth = true;
    };
  };

  # Remove all default packages
  environment.defaultPackages = mkForce [ ];

  boot = {
    # Make tmp volatile, using tmpfs is speedy on SSD systems
    tmpOnTmpfs = mkDefault true;
    cleanTmpDir = mkDefault (!config.boot.tmpOnTmpfs);

    # Use the latest Linux kernel
    kernelPackages = pkgs.linuxPackages_latest;
  };

  programs = {
    # Allow non-root users to allow other users to access mount point
    fuse.userAllowOther = mkDefault true;

    # Enable dconf for programs that need it
    dconf.enable = true;
  };

  bud.enable = lib.mkDefault true;

  services = {
    # Ensure certain necessary directories always exist
    ensure.directories = [ "/mnt" ];

    # Enable Early Out of Memory service
    earlyoom.enable = true;

    # For rage encryption, all hosts need a ssh key pair
    openssh = {
      enable = true;
      openFirewall = lib.mkDefault true;
      forwardX11 = lib.mkDefault false;
      hostKeys = lib.mkDefault [
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
  };

  # FIX: command-not-found database doesn't exist normally
  system.activationScripts.channels-update.text = ''
    ${pkgs.nix}/bin/nix-channel --update
  '';
}
