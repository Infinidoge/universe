{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.our.flattenListSet {
    suites = suites.graphic;
    imports = [ ];
    profiles = with profiles; [
      boot.grub

      networking.wireless

      (with hardware; [
        sound
        laptop
        gpu.intel
      ])
    ];
  };

  services.fprintd.enable = true;
}
