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
      enable = mkBoolOpt false;
      package = mkOpt package pkgs.steam;
    };
    polymc = {
      enable = mkBoolOpt false;
      package = mkOpt package pkgs.polymc;
    };
    lutris = {
      enable = mkBoolOpt false;
      packages = mkOpt package pkgs.lutris;
    };
  };

  config = mkMerge [
    {
      home.home.packages = with pkgs; [
        (mkIf cfg.polymc.enable cfg.polymc.package)
        (mkIf cfg.lutris.enable cfg.lutris.packages)
      ];

      modules.software.steam = {
        enable = mkAliasDefinitions opt.steam.enable;
        package = mkAliasDefinitions opt.steam.package;
      };
    }

    (mkIf cfg.enableAll {
      modules.desktop.gaming = {
        steam.enable = true;
        polymc.enable = true;
        lutris.enable = true;
      };
    })
  ];
}
