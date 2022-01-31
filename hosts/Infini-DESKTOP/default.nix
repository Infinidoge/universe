{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.lists.flatten [
    (with suites; [
      graphic
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

      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"

      "/root/.local/share/nix/trusted-settings.json"
      "/root/.ssh/known_hosts"
    ];
  };

  hardware.nvidia.powerManagement.enable = false;

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
    filesystems = {
      enable = true;
      btrfs.enable = true;
    };
    desktop = {
      gaming.enableAll = true;
    };
    virtualization.enable = true;
  };

  networking.interfaces = {
    eth0.useDHCP = true;
    wlp41s0.useDHCP = true;
  };

  home = { profiles, ... }: {
    imports = with profiles; [ stretchly ];
  };
}
