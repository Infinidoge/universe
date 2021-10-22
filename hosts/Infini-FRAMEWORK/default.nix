{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.lists.flatten [
    (with suites; [ graphic ])

    (with profiles; [
      boot.grub

      networking.wireless

      (with hardware; [
        sound
        laptop
        gpu.intel
      ])
    ])
  ];

  system.stateVersion = "21.11";

  services.fprintd.enable = true;
}
