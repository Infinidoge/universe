{ ... }: {
  imports = [ ./common.nix ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  services.xserver.videoDrivers = [ "amdgpu" ];
}
