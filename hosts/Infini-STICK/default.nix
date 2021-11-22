{ lib, suites, profiles, ... }: {
  imports = lib.lists.flatten [
    (with suites; [ base develop ])

    (with profiles; [
      networking.wireless

      btrfs

      # services.privoxy
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
  };

  system.stateVersion = "21.11";
}
