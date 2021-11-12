{ ... }: {
  imports = [ ./common.nix ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
  };

  virtualisation.docker.enableNvidia = true;
}
