{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.lists.flatten [
    (with suites; [
      base
    ])

    (with profiles; [
      (with hardware; [
        rpi
        wireless
      ])

      networking.wireless
    ])
  ];
}
