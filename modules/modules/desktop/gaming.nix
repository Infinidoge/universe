{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.our;
let
  cfg = config.modules.desktop.gaming;
  opt = options.modules.desktop.gaming;
in
{
  options.modules.desktop.gaming = with types; {
    enableAll = mkBoolOpt false;
    steam = {
      enable = mkBoolOpt cfg.enableAll;
      package = mkOpt package pkgs.steam;
    };
    prismlauncher = {
      enable = mkBoolOpt cfg.enableAll;
      package = mkOpt package pkgs.prismlauncher;
    };
    lutris = {
      enable = mkBoolOpt false;
      package = mkOpt package pkgs.lutris;
    };
    olympus = {
      enable = mkBoolOpt cfg.enableAll;
      package = mkOpt package pkgs.olympus;
    };
    puzzles = {
      enable = mkBoolOpt cfg.enableAll;
      package = mkOpt package pkgs.sgt-puzzles;
    };
  };

  config = mkMerge [
    {
      assertions = [
        {
          assertion =
            (any id (
              with cfg;
              [
                steam.enable
                prismlauncher.enable
                lutris.enable
                olympus.enable
                puzzles.enable
              ]
            ))
            -> config.info.graphical;
          message = "Games cannot be enabled in a non-graphical environment";
        }
      ];

      home.home.packages = with pkgs; [
        (mkIf cfg.prismlauncher.enable cfg.prismlauncher.package)
        (mkIf cfg.prismlauncher.enable unbted)
        alsa-oss
        (mkIf cfg.lutris.enable cfg.lutris.package)
        (mkIf cfg.olympus.enable cfg.olympus.package)
        (mkIf cfg.puzzles.enable cfg.puzzles.package)
        (mkIf cfg.steam.enable protonup-ng)
        (mkIf cfg.steam.enable wineWowPackages.stable)
      ];

      programs.steam = {
        enable = mkAliasDefinitions opt.steam.enable;
        package = cfg.steam.package.override (
          optionalAttrs config.modules.hardware.gpu.nvidia {
            extraProfile = ''
              unset VK_ICD_FILENAMES
              export VK_ICD_FILENAMES=${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.json:${config.hardware.nvidia.package.lib32}/share/vulkan/icd.d/nvidia_icd32.json
            '';
          }
        );
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    }
  ];
}
