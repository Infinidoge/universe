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

  environment.persistence."/persist" = { };

  system.stateVersion = "21.11";
}
