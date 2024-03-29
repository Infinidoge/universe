{ config, lib, ... }:
with lib;
{
  # Security settings based on https://github.com/hlissner/dotfiles/blob/master/modules/security.nix
  security = {
    sudo.extraConfig = ''
      Defaults lecture=never
    '';
    acme = {
      acceptTerms = true;
      defaults.email = "infinidoge@inx.moe";
    };

    pam.sshAgentAuth = {
      enable = true;
      authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
    };
  };

  hardware = {
    enableRedistributableFirmware = mkDefault true;
    cpu.amd.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
  };

  users.mutableUsers = false;

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
    settings.X11Forwarding = mkDefault false;
    hostKeys = mkDefault [{
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
    }];
  };

  services.nginx = {
    statusPage = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  };

  common = {
    nginx.ssl = { sslCertificate = config.secrets."inx.moe.pem"; sslCertificateKey = config.secrets."inx.moe.key"; forceSSL = true; };
  };
}
