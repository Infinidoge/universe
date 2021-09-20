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

  services.xserver.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  system.stateVersion = "21.11";

  networking.interfaces.wlan0.useDHCP = true;

}
