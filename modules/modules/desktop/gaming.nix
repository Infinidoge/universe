{ config, options, lib, pkgs, ... }:
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
      enable = mkBoolOpt cfg.enableAll;
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
      home.home.packages = with pkgs; [
        (mkIf cfg.prismlauncher.enable cfg.prismlauncher.package) alsa-oss
        (mkIf cfg.lutris.enable cfg.lutris.package)
        (mkIf cfg.olympus.enable cfg.olympus.package)
        (mkIf cfg.puzzles.enable cfg.puzzles.package)
      ];

      modules.software.steam = {
        enable = mkAliasDefinitions opt.steam.enable;
        package = mkAliasDefinitions opt.steam.package;
      };
    }
  ];
}
