{ config, lib, pkgs, ... }:
with lib;
with lib.our;
let
  cfg = config.modules.hardware.gpu;
  any' = any (v: v);
in
{
  options.modules.hardware.gpu = {
    amdgpu = mkBoolOpt false;
    nvidia = mkBoolOpt false;
    intel = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf (any' (with cfg; [ amdgpu nvidia intel ])) {
      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;

        extraPackages = with pkgs; flatten [
          libvdpau-va-gl
          vaapiVdpau

          (optionals cfg.intel [
            intel-media-driver
            vaapiIntel
          ])

          (optionals cfg.nvidia [
            nvidia-vaapi-driver
          ])
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
        modesetting.enable = mkDefault true;
        powerManagement.enable = mkDefault true;
      };

      virtualisation.docker.enableNvidia = true;
    })

    (mkIf cfg.intel { })
  ];
}
