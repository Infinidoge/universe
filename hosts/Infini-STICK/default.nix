{ lib, suites, profiles, ... }: {
  imports = lib.lists.flatten [
    (with suites; [ base develop ])

    (with profiles; [
      boot.grub

      networking.wireless

      (with hardware; [
        sound
        (with gpu; [
          amdgpu
          intel
          nvidia
        ])
        laptop
      ])

      btrfs

      # services.privoxy
    ])

    ./hardware-configuration.nix
  ];

  # networking.interfaces.wlp170s0.useDHCP = true;
  networking.interfaces.enp39s0.useDHCP = true;

  system.stateVersion = "21.11";
}
