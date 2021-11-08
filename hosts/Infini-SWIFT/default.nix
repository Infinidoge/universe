{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.our.flattenListSet {
    suites = with suites; [ graphic develop ];
    imports = [ ./hardware-configuration.nix ];
    profiles = with profiles;
      [
        boot.grub

        networking.wireless

        (with hardware; [
          sound
          gpu.amdgpu
          laptop
          wireless
        ])

        btrfs
        # peripherals.printing

        services.privoxy
      ];
  };

  system.stateVersion = "21.11";

  powerManagement.resumeCommands = "${pkgs.kmod}/bin/rmod atkbd; ${pkgs.kmod}/bin/modprobe atkbd reset=1";

  networking.interfaces.wlan0.useDHCP = true;


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
