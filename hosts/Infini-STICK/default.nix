{ lib, suites, profiles, ... }: {
  imports = lib.lists.flatten [
    (with suites; [ base develop ])

    (with profiles; [
      networking.wireless
    ])

    ./hardware-configuration.nix
  ];

  # networking.interfaces.wlp170s0.useDHCP = true;
  networking.interfaces.enp39s0.useDHCP = true;

  modules = {
    boot.grub.enable = true;
    hardware = {
      audio.enable = true;
      form.portable = true;
    };
    services.proxy.enable = true;
    filesystems = {
      enable = true;
      btrfs.enable = true;
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/home"
      "/etc/nixos"

      "/root/.local/share/nix"
      "/root/.ssh"

      # /etc directories
      "/etc/ssh"

      # /var directories
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/systemd/coredump"
      "/var/db/sudo/lectured"
    ];

    files = [
      "/etc/machine-id"
    ];
  };

  system.stateVersion = "21.11";
}
