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

      ./hardware-configuration.nix
    ])
  ];

  system.stateVersion = "21.11";

  networking.interfaces.wlp170s0.useDHCP = true;

  services.fprintd.enable = true;
}
