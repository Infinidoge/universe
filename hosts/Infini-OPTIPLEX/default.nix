{ config, pkgs, lib, private, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix

    ./vaultwarden.nix
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

  info.loc.home = false;

  networking = {
    interfaces = {
      enp0s31f6 = {
        ipv4.addresses = [{
          address = "128.210.6.103";
          prefixLength = 28;
        }];
      };
    };
    defaultGateway = {
      address = "128.210.6.97";
      interface = "enp0s31f6";
    };
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

  services.nginx = {
    enable = true;

    statusPage = true;

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  };
}
