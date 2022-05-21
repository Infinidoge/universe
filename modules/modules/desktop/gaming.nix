{ config, options, lib, pkgs, ... }:
with lib;
with lib.hlissner;
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
    polymc = {
      enable = mkBoolOpt cfg.enableAll;
      package = mkOpt package pkgs.polymc;
    };
    lutris = {
      enable = mkBoolOpt cfg.enableAll;
      package = mkOpt package pkgs.lutris;
    };
  };

  config = mkMerge [
    {
      home.home.packages = with pkgs; [
        (mkIf cfg.polymc.enable cfg.polymc.package)
        (mkIf cfg.lutris.enable cfg.lutris.package)
      ];

      modules.software.steam = {
        enable = mkAliasDefinitions opt.steam.enable;
        package = mkAliasDefinitions opt.steam.package;
      };
    }
  ];
}
