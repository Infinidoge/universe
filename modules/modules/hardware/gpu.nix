{ config, lib, pkgs, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.modules.hardware.gpu;
in
{
  options.modules.hardware.gpu = {
    amdgpu = mkBoolOpt false;
    nvidia = mkBoolOpt false;
    intel = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf (any (with cfg; [ amdgpu nvidia intel ])) {
      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;

        extraPackages = with pkgs; [
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
    })

    (mkIf cfg.amdgpu {
      boot.initrd.kernelModules = [ "amdgpu" ];
      services.xserver.videoDrivers = [ "amdgpu" ];
    })

    (mkIf cfg.nvidia {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
      };

      virtualisation.docker.enableNvidia = true;
    })

    (mkIf cfg.intel {
      hardware.opengl.extraPackages = with pkgs; [ intel-media-driver vaapiIntel ];
    })
  ];
}
