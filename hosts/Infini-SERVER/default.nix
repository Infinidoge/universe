{ config, pkgs, lib, private, ... }: {
  imports = [
    private.nixosModules.minecraft-servers
    private.nixosModules.nitter
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "22.05";

  info.loc.home = true;

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

    soft-serve-ng.enable = true;
  };

  services.minecraft-servers.servers.emd-server.autoStart = false;

  persist = {
    directories = [
      "/home"
      "/etc/nixos"
      "/etc/nixos-private"

      # /var directories
      "/var/log"
      "/var/lib/systemd/coredump"
      "/var/lib/tailscale"
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

  services = {
    nginx =
      let
        cfg = config.services.nginx;
        inherit (config.common.nginx) ssl;
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
          "thelounge.inx.moe" = ssl // {
            locations."/" = {
              proxyPass = "http://localhost:${toString config.services.thelounge.port}";
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
