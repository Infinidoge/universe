{ suites, profiles, pkgs, ... }: {
  imports = suites.graphic
    ++ [ ./hardware-configuration.nix ]
    ++ (with profiles;
    [
      boot.systemd-boot

      networking.wireless
      hardware.sound
      hardware.amdgpu
      # peripherals.printing
    ]
  );

  system.stateVersion = "21.11";

  networking.interfaces.wlan0.useDHCP = true;

}
