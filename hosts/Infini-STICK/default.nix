{ lib, suites, profiles, ... }: {
  imports = lib.lists.flatten [
    (with suites; [ base develop ])

    (with profiles; [
      boot.grub

      networking.wireless

      (with hardware; [
        sound
        gpu.amdgpu
        gpu.intel
        laptop
      ])

      btrfs

      services.privoxy
    ])

    ./hardware-configuration.nix
  ];

  networking.interfaces.wlp170s0.useDHCP = true;

  system.stateVersion = "21.11";
}
