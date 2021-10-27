{ lib, suites, profiles, ... }: {
  imports = lib.lists.flatten [
    (with suites; [ graphic develop ])

    (with profiles; [
      boot.grub

      networking.wireless

      (with hardware; [
        sound
        gpu.common
      ])

      btrfs
    ])
  ];

  system.stateVersion = "21.11";
}
