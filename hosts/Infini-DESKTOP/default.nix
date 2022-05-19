{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.lists.flatten [
    (with suites; [
      base
      develop
    ])

    (with profiles; [
      networking.wireless
    ])

    ./hardware-configuration.nix
  ];

  system.stateVersion = "21.11";

  environment.persistence."/persist" = {
    directories = [
      "/home"
      "/etc/nixos"

      # /var directories
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/systemd/coredump"
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

  modules = {
    boot.grub.enable = true;
    hardware = {
      gpu.nvidia = true;
      wireless.enable = true;
      form.desktop = true;

      peripherals.razer.enable = true;
    };
    services = {
      foldingathome = {
        enable = false;
        user = "Infinidoge";
        extra = {
          control = true;
          viewer = true;
        };
      };
    };
    desktop = {
      wm.enable = true;
      gaming.enableAll = true;
    };
    virtualization.enable = true;
  };

  networking.interfaces = {
    eth0.useDHCP = true;
    wlp41s0.useDHCP = true;
  };

  home = { profiles, pkgs, ... }: {
    imports = with profiles; [ stretchly ];
    home.packages = with pkgs; [
      hydrus
    ];
  };
}
