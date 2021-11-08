{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.lists.flatten [
    (with suites; [
      graphic
      develop
    ])

    (with profiles; [
      boot.grub

      networking.wireless

      (with hardware; [
        sound
        gpu.nvidia
      ])

      btrfs
    ])

    ./hardware-configuration.nix
  ];

  system.stateVersion = "21.05";

  networking.interfaces = {
    eth0.useDHCP = true;
    wlp41s0.useDHCP = true;
  };

  home-manager.users.infinidoge = { profiles, ... }: {
    imports = with profiles; [ stretchly ];
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
