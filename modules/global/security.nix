{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  inherit (config.nixpkgs.hostPlatform) system;
in
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
    pki.certificateFiles = [
      (pkgs.fetchurl {
        url = "https://files.inx.moe/ca/ca.cert.pem";
        hash = "sha256-YZKiWLnO7uSHYJeNfTVxN87xMSPbJC7iTif3lMtUxpI=";
      })
      (pkgs.fetchurl {
        url = "https://files.inx.moe/ca/intermediate.cert.pem";
        hash = "sha256-NpVi8Uv2IaxCq+laQp+YL1xrJeIFeDZv5SKAWT1bzGQ=";
      })
    ];
    polkit.enable = true;
  };

  hardware = {
    enableRedistributableFirmware = mkDefault true;
    cpu.intel.updateMicrocode = mkDefault (
      config.hardware.enableRedistributableFirmware && system == "x86_64-linux"
    );
    cpu.amd.updateMicrocode = mkDefault (
      config.hardware.enableRedistributableFirmware && system == "x86_64-linux"
    );
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
      "100.101.102.0/14" # Tailscale
      "172.16.0.0/12" # Docker/Containers
      "10.0.0.0/8" # Private networks
      "100.64.0.0/10" # CGNAT
      "192.168.1.0/24" # Private networks
      "192.168.137.0/24" # Rack network
      "128.46.0.0/16" # Purdue
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
}
