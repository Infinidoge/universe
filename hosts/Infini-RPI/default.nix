{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.lists.flatten [
    (with suites; [
      base
    ])

    (with profiles; [
      networking.wireless
    ])
  ];

  modules.hardware.form.raspi = true;
}
