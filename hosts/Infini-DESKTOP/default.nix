{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = lib.lists.flatten [
    ./hardware-configuration.nix
    ./filesystems.nix
    ./privoxy.nix
  ];

  system.stateVersion = "21.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7uX1myj9ghv7wMoL038oGDCdScdyLd7RvYdnoioSBh root@Infini-DESKTOP";

  info.loc.home = true;

  persist.directories = [
    "/srv"
  ];

  modules = {
    hardware = {
      gpu.nvidia = true;
      wireless.enable = true;
      form.desktop = true;
    };
    services = {
      apcupsd = {
        enable = true;
        primary = true;
        config = {
          address = "0.0.0.0";
        };
      };
    };
    desktop = {
      wm.enable = true;
      gaming.enableAll = true;
      gaming.olympus.enable = false; # Build is currently broken
    };

    backups.extraExcludes = [
      "/home/infinidoge/Hydrus"
    ];
  };

  services.printing.enable = true;

  virtualisation.enable = true;

  universe.programming.all.enable = true;

  home.home.packages = with pkgs; [
    arduino
    hydrus
    razergenie # TODO: replace with polychromatic

    sidequest
    unityhub
    vrc-get
    blender
  ];

  programs.ns-usbloader.enable = true;
  programs.minipro.enable = true;

  hardware.openrazer = {
    enable = false; # https://github.com/NixOS/nixpkgs/issues/393664
    users = [ config.user.name ];
  };

  services.minecraft-servers = {
    enable = true;

    servers = { };
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];
}
