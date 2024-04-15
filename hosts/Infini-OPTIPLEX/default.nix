{ config, pkgs, lib, private, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix

    ./factorio.nix
    ./freshrss.nix
    ./thelounge.nix
    ./vaultwarden.nix
    ./jellyfin.nix
  ];

  system.stateVersion = "23.05";

  info.loc.purdue = true;

  modules = {
    boot = {
      grub.enable = true;
      timeout = 1;
    };

    hardware = {
      form.server = true;
    };
  };

  networking = {
    firewall = {
      allowedUDPPorts = [ 80 443 ];
      allowedTCPPorts = [ 80 443 ];
    };
  };

  persist = {
    directories = [
      "/home"
      "/etc/nixos"
      "/etc/nixos-private"

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

  services.fail2ban.enable = true;

  services.nginx = {
    enable = true;

    virtualHosts =
      let
        cfg = config.services.nginx;
        inherit (config.common.nginx) ssl ssl-optional;
      in
      {
        "*.inx.moe" = ssl // {
          globalRedirect = "inx.moe";
        };
        "blahaj.inx.moe" = ssl-optional // {
          locations."/" = {
            tryFiles = "/Blahaj.png =404";
            root = ./static;
          };
        };
        "nitter.inx.moe" = ssl // {
          globalRedirect = "twitter.com";
        };
        "ponder.inx.moe" = ssl // {
          locations."/".root = pkgs.ponder;
        };
      };
  };
}
