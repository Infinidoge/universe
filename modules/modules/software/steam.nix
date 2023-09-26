{ config, lib, pkgs, ... }:
with lib;
with lib.our;
let
  cfg = config.modules.software.steam;

  hw = config.modules.hardware;

  steam = cfg.package.override {
    extraLibraries = (pkgs:
      (with config.hardware.opengl;
      if pkgs.hostPlatform.is64bit
      then [ package ] ++ extraPackages
      else [ package32 ] ++ extraPackages32)

      ++ (with pkgs; [ pipewire ]));
  };
in
{
  options.modules.software.steam = with types; {
    enable = mkBoolOpt false;
    package = let pkg = pkgs.steam; in
      mkOpt package
        (if hw.gpu.nvidia
        then
          pkg.override
            {
              extraProfile = ''
                unset VK_ICD_FILENAMES
                export VK_ICD_FILENAMES=${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.json:${config.hardware.nvidia.package.lib32}/share/vulkan/icd.d/nvidia_icd32.json
              '';
            }
        else pkg);
  };

  config = mkMerge [
    {
      assertions = [{
        assertion = if cfg.enable then config.info.graphical else true;
        message = "Steam cannot be enabled in a non-graphical environment";
      }];
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
        pkgs.wineWowPackages.stable
      ];
    })
  ];
}
