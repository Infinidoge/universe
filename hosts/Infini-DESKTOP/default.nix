{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.our.flattenListSet {
    suites = suites.graphic;
    imports = [ ./hardware-configuration.nix ];
    profiles = with profiles; [
      boot.systemd-boot

      networking.wireless
      hardware.sound
      hardware.nvidia
      # peripherals.printing
    ];
  };

  system.stateVersion = "21.05";

  networking.interfaces = {
    eth0.useDHCP = true;
    wlp41s0.useDHCP = true;
  };
}
