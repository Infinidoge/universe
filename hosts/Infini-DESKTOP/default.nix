{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.lists.flatten [
    (with suites; [
      graphic
      develop
    ])

    (with profiles; [
      networking.wireless

      virtualization
    ])

    ./hardware-configuration.nix
  ];

  system.stateVersion = "21.05";

  modules = {
    boot.grub.enable = true;
    hardware = {
      gpu.nvidia = true;
      wireless.enable = true;
      form.desktop = true;
    };
    services = {
      foldingathome = {
        enable = true;
        user = "Infinidoge";
        extra = {
          control = true;
          viewer = true;
        };
      };
    };
    filesystems = {
      enable = true;
      btrfs.enable = true;
    };
    software = {
      steam.enable = true;
    };
  };

  networking.interfaces = {
    eth0.useDHCP = true;
    wlp41s0.useDHCP = true;
  };

  home = { profiles, ... }: {
    imports = with profiles; [ stretchly ];
  };
}
