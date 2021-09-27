{ suites, profiles, pkgs, lib, test, ... }: {
  imports = test.flattenListSet {
    suites = suites.graphic;
    imports = [ ./hardware-configuration.nix ];
    profiles = with profiles;
      [
        boot.grub

        networking.wireless

        (with hardware; [
          sound
          amdgpu
          laptop
        ])
        # peripherals.printing
      ];
  };

  system.stateVersion = "21.11";

  powerManagement.resumeCommands = "${pkgs.kmod}/bin/rmod atkbd; ${pkgs.kmod}/bin/modprobe atkbd reset=1";

  networking.interfaces.wlan0.useDHCP = true;

}
