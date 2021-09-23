{ suites, profiles, pkgs, ... }: {
  imports = suites.graphic
    ++ [ ./hardware-configuration.nix ]
    ++ (with profiles;
    [
      boot.grub

      networking.wireless
      hardware.sound
      hardware.amdgpu
      # peripherals.printing
    ]
  );

  info.monitors = 1;

  services.xserver.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  system.stateVersion = "21.11";

  networking.interfaces.wlan0.useDHCP = true;

}
