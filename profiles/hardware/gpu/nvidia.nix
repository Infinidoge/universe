{ ... }: {
  imports = [ ./common.nix ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia.modesetting.enable = true;
}
