{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.our.flattenListSet {
    suites = with suites; [ graphic develop ];
    imports = [ ./hardware-configuration.nix ];
    profiles = with profiles; [
      boot.systemd-boot

      networking.wireless
      hardware.sound
      hardware.gpu.nvidia
      # peripherals.printing
    ];
  };

  system.stateVersion = "21.05";

  networking.interfaces = {
    eth0.useDHCP = true;
    wlp41s0.useDHCP = true;
  };

  # services.minecraft-servers = {
  #   enable = true;
  #   openFirewall = true;

  #   servers = {
  #     test = {
  #       enable = true;
  #       eula = true;
  #       # declarative = true;
  #       # serverProperties.server-port = 25565;
  #     };

  #     # test2 = {
  #     #   enable = true;
  #     #   eula = true;
  #     #   declarative = true;
  #     #   serverProperties.server-port = 25566;
  #     # };
  #   };
  # };
}
