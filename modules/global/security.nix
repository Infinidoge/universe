{ config, lib, ... }:
with lib;
{
  security = {
    sudo.wheelNeedsPassword = false;
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

  # For permission to access smtp password
  users.groups.smtp = { };

  common = rec {
    domain = "inx.moe";
    subdomain = subdomain: "${subdomain}.${domain}";

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

    email = rec {
      withUser = user: "${user}@${domain}";
      outgoingUser = "noreply";
      incomingUser = "incoming";
      outgoing = withUser outgoingUser;
      incoming = withUser incomingUser;
      withSubaddress = subaddress: "${outgoingUser}+${subaddress}@${domain}";

      smtp = {
        address = "smtp.purelymail.com";
        SSLTLS = 465;
        STARTTLS = 587;
      };
      imap = {
        address = "imap.purelymail.com";
        port = 993;
      };
    };
  };
}
