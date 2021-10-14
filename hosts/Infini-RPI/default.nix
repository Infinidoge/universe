{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.lists.flatten [
    (with suites; [
      base
    ])

    (with profiles; [
      hardware.rpi

      networking.wireless
    ])
  ];
}
