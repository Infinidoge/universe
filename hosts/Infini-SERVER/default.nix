{ config, pkgs, lib, private, ... }: {
  imports = lib.flatten [
    private.nixosModules.minecraft-servers
    private.nixosModules.nitter
    ./hardware-configuration.nix
    ./filesystems.nix
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
      enable = false;
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
      "/etc/nixos-private"

      # /var directories
      "/var/log"
      "/var/lib/systemd/coredump"
      "/var/lib/tailscale"
      "/var/lib/bitwarden_rs"
      "/var/lib/thelounge"

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
  age.secrets."vaultwarden".owner = "vaultwarden";
  age.secrets."vaultwarden".group = "vaultwarden";

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
          "bitwarden.inx.moe" = ssl // {
            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
            };
          };
          "thelounge.inx.moe" = ssl // {
            locations."/" = {
              proxyPass = "http://localhost:${toString config.services.thelounge.port}";
            };
          };
        };
      };

    vaultwarden = {
      enable = true;
      environmentFile = config.secrets."vaultwarden";
      config = {
        DOMAIN = "https://bitwarden.inx.moe";
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";

        PUSH_ENABLED = true;
        PUSH_RELAY_URI = "https://push.bitwarden.com";

        SMTP_HOST = "live.smtp.mailtrap.io";
        SMTP_FROM = "noreply@inx.moe";
        SMTP_PORT = 587;
        SMTP_SECURITY = "starttls";
        SMTP_USERNAME = "api";
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

    thelounge = {
      enable = true;
      plugins = with pkgs.theLoungePlugins; [
        themes.zenburn-monospace
        themes.dracula
        themes.discordapp
      ];
      port = 9786;
      extraConfig = {
        reverseProxy = true;
      };
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 80 443 ];
    allowedTCPPorts = [ 80 443 ];
  };
}
