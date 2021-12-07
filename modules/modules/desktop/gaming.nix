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
    multimc = {
      enable = mkBoolOpt false;
      msaClientID = mkOpt str "01524508-0110-46fc-b468-362d31ca41e6";
      package = mkOpt package pkgs.multimc;
    };
    lutris = {
      enable = mkBoolOpt false;
      packages = mkOpt package pkgs.lutris;
    };
  };

  config = mkMerge [
    {
      home.home.packages = with pkgs; [
        (mkIf cfg.multimc.enable (cfg.multimc.package.override { msaClientID = cfg.multimc.msaClientID; }))
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
        multimc.enable = true;
        lutris.enable = true;
      };
    })
  ];
}
