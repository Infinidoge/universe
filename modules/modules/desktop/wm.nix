{ pkgs, lib, config, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.modules.desktop.wm;
in
{
  options.modules.desktop.wm = {
    enable = mkBoolOpt false;
    qtile.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      info = {
        graphical = mkDefault true;
        monitors = mkDefault 1;
      };

      services.xserver = {
        enable = true;
        displayManager.lightdm.enable = true;
      };

      home-manager.sharedModules = [{
        xsession.enable = true;
      }];

      environment.systemPackages = with pkgs; flatten [
        (with xorg; [
          xwininfo
          xprop
        ])

        xsecurelock
        blugon
      ];
    }
    (mkIf cfg.qtile.enable {
      services.xserver.windowManager.qtile.enable = true;

      info.env.wm = "qtile";

      fonts.packages = with pkgs; [
        powerline-fonts
        ubuntu_font_family
      ];
    })
  ]);
}
