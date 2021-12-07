{ config, lib, pkgs, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.modules.software.steam;

  hw = config.modules.hardware;

  steam = pkgs.steam.override {
    extraLibraries = (pkgs:
      (with config.hardware.opengl;
      if pkgs.hostPlatform.is64bit
      then [ package ] ++ extraPackages
      else [ package32 ] ++ extraPackages32)

      ++ (with pkgs; [ pipewire ]));


    extraProfile = mkIf hw.gpu.nvidia ''
      unset VK_ICD_FILENAMES
      export VK_ICD_FILENAMES=${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.json:${config.hardware.nvidia.package.lib32}/share/vulkan/icd.d/nvidia_icd32.json
    '';
  };
in
{
  options.modules.software.steam = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    {
      assertions = [
        {
          assertion = cfg.enable && !config.info.graphical;
          message = "Steam cannot be enabled in a non-graphical environment";
        }
      ];
    }

    (mkIf cfg.enable {
      # Taken from the programs.steam option, reimplemented here to move software into userland
      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };

      hardware.pulseaudio.support32Bit = config.hardware.pulseaudio.enable;

      hardware.steam-hardware.enable = true;

      home.home.packages = [
        steam
        steam.run

        pkgs.protonup
      ];
    })
  ];
}
