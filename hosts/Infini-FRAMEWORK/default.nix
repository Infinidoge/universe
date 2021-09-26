{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.our.flattenListSet {
    suites = suites.graphic;
    imports = [ ];
    profiles = with profiles; [
      boot.grub

      networking.wireless
      hardware.sound
    ];
  };

  services.fprintd.enable = true;
}
