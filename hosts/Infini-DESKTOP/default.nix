{ suites, profiles, pkgs, ... }: {
  imports = suites.graphic
    ++ [ ./hardware-configuration.nix ]
    ++ (with profiles;
    [
      boot.systemd-boot

      networking.wireless
      hardware.sound
      hardware.nvidia
      # peripherals.printing
    ]);

  system.stateVersion = "21.05";

  bud.localFlakeClone = "/etc/nixos";

  networking.interfaces = {
    eth0.useDHCP = true;
    wlp41s0.useDHCP = true;
  };
}
