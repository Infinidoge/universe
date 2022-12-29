{ config, suites, profiles, pkgs, lib, ... }: {
  imports = lib.flatten [
    (with suites; [ base ])

    ./hardware-configuration.nix
  ];

  system.stateVersion = "22.05";

  modules = {
    boot = {
      grub.enable = true;
      timeout = 1;
    };
    hardware = {
      # gpu.nvidia = true;
      form.server = true;
    };
    services.apcupsd = {
      enable = true;
      primary = false;
      config = {
        address = "192.168.1.212";
      };
    };
  };

  services = {
    avahi.reflector = true;

    soft-serve.enable = true;
  };

  environment.persistence."/persist" = {
    directories = [
      "/home"
      "/etc/nixos"

      # /var directories
      "/var/log"
      "/var/lib/systemd/coredump"
      "/var/lib/tailscale"

      "/srv"
    ];

    files = [
      "/etc/machine-id"

      "/root/.local/share/nix/trusted-settings.json"
      "/root/.ssh/known_hosts"
      "/root/.ssh/id_ed25519"
      "/root/.ssh/id_ed25519.pub"
      "/root/.ssh/immutable_files.txt"
    ];
  };

  age.secrets."inx.moe.pem".owner = "nginx";
  age.secrets."inx.moe.pem".group = "nginx";
  age.secrets."inx.moe.key".owner = "nginx";
  age.secrets."inx.moe.key".group = "nginx";

  services = {
    nginx =
      let
        cfg = config.services.nginx;
        ssl = { sslCertificate = config.secrets."inx.moe.pem"; sslCertificateKey = config.secrets."inx.moe.key"; forceSSL = true; };
      in
      {
        enable = true;

        statusPage = true;

        recommendedTlsSettings = true;
        recommendedOptimisation = true;
        recommendedGzipSettings = true;
        recommendedProxySettings = true;

        virtualHosts = {
          "*.inx.moe" = ssl // {
            listen = lib.flatten
              (map
                (addr: [
                  { inherit addr; port = 443; ssl = true; }
                  { inherit addr; port = 80; ssl = false; }
                ])
                cfg.defaultListenAddresses);

            globalRedirect = "inx.moe";
          };
          "nitter.inx.moe" = ssl // {
            locations."/" = {
              proxyPass = "http://localhost:8000";
            };
          };
        };
      };

    nitter = rec {
      enable = true;
      server = {
        title = "Nitter | inx.moe";
        port = 8000;
        hostname = "nitter.inx.moe";
      };
      openFirewall = true;
      preferences = {
        hideTweetStats = true;
        hlsPlayback = true;
        infiniteScroll = true;
        proxyVideos = true;
        replaceTwitter = server.hostname;
        theme = "Black";
      };
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 80 443 ];
    allowedTCPPorts = [ 80 443 ];
  };
}
