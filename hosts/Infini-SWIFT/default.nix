{ suites, profiles, pkgs, lib, test, ... }: {
  imports = test.flattenListSet {
    suites = suites.graphic;
    imports = [ ./hardware-configuration.nix ];
    profiles = with profiles;
      [
        boot.grub

        networking.wireless
        hardware.sound
        hardware.amdgpu
        # peripherals.printing
      ];
  };

  info.monitors = 1;

  services.xserver.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  system.stateVersion = "21.11";

  networking.interfaces.wlan0.useDHCP = true;

}
