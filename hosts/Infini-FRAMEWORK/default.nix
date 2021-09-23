{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.flattenListSet {
    suites = suites.graphical;
    imports = [ ];
    profiles = with profiles; [
      boot.grub

      networking.wireless
      hardware.sound
    ];
  };

  services.fprintd.enable = true;
}
