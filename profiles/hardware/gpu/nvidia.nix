{ config, pkgs, lib, ... }:
let
  nvidia_x11 = config.boot.kernelPackages.nvidia_x11;
  nvidia_gl = nvidia_x11.out;
  nvidia_gl_32 = nvidia_x11.lib32;
in
{
  imports = [ ./common.nix ];

  services.xserver.videoDrivers = [ "nvidia" ];

  boot = {
    blacklistedKernelModules = [ "nouveau" ];
    extraModulePackages = [ nvidia_x11 ];
  };

  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
    };
    opengl = {
      extraPackages = [ nvidia_gl ];
      extraPackages32 = [ nvidia_gl_32 ];
    };
  };

  systemd.services.nvidia-control-devices = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${nvidia_x11.bin}/bin/nvidia-smi";
  };

  virtualisation.docker.enableNvidia = true;
}
