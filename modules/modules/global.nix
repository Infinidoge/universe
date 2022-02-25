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

  boot = {
    # Make tmp volatile, using tmpfs is speedy on SSD systems
    tmpOnTmpfs = mkDefault true;
    cleanTmpDir = mkDefault (!config.boot.tmpOnTmpfs);
  };

  # Allow non-root users to allow other users to access mount point
  programs.fuse.userAllowOther = mkDefault true;

  # Ensure certain necessary directories always exist
  services.ensure.directories = [ "/mnt" ];

  # FIX: command-not-found database doesn't exist normally
  system.activationScripts.channels-update.text = ''
    ${pkgs.nix}/bin/nix-channel --update
  '';
}
