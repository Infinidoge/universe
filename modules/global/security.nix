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
      defaults = {
        email = "infinidoge@inx.moe";
        dnsProvider = "cloudflare";
        environmentFile = config.secrets.cloudflare;
      };
    };

    pam.sshAgentAuth = {
      enable = true;
      authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
    };
  };

  hardware = {
    enableRedistributableFirmware = mkDefault true;
    cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
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
    settings = {
      X11Forwarding = mkDefault false;
      GatewayPorts = mkDefault "yes";
    };
    hostKeys = mkDefault [{
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  programs.ssh = {
    extraConfig = with config.common; ''
      Host rsync.net
          Hostname ${rsyncnet.host}
          User ${rsyncnet.user}

      Host admin.rsync.net
          Hostname ${rsyncnet.host}
          User ${rsyncnet.account}
    '';
  };

  services.nginx = {
    statusPage = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  };

  services.fail2ban = {
    ignoreIP = [
      "100.101.102.0/14"
      "172.16.0.0/12"
      "192.168.1.0/24"
      "192.168.137.0/24"
    ];
    bantime = "24h";
    bantime-increment = {
      enable = true;
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };
  };

  common = {
    nginx = rec {
      ssl-cert = {
        enableACME = true;
        acmeRoot = null;
      };
      ssl-optional = ssl-cert // {
        addSSL = true;
      };
      ssl = ssl-cert // {
        forceSSL = true;
      };
    };

    rsyncnet = rec {
      account = "de3482";
      user = "${account}s1";
      host = "${account}.rsync.net";
    };
  };
}
