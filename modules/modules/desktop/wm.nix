{
  config,
  common,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.our;
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

      common.wm = {
        locker = pkgs.xsecurelock;
      };

      # Compositor to prevent screen tearing
      services.picom = {
        enable = true;
        backend = "glx";
        vSync = true;
      };

      programs.xss-lock = {
        enable = true;
        lockerCommand = lib.getExe common.wm.locker;
      };

      # Automatically attach/detatch connected/disconnected monitors
      services.autorandr = {
        enable = config.info.graphical && !config.info.stationary;
        ignoreLid = true;
        defaultTarget = "horizontal";
      };

      services.xserver.enable = true;
      services.xserver.enableTearFree = true;

      services.xserver.displayManager = {
        lightdm.enable = true;
      };

      home-manager.sharedModules = [
        {
          xsession.enable = true;
        }
      ];

      environment.systemPackages =
        with pkgs;
        flatten [
          (with xorg; [
            xwininfo
            xprop
          ])
          xclip
          xdotool

          pavucontrol

          common.wm.locker
        ];
    }
    (mkIf cfg.qtile.enable {
      services.xserver.windowManager.qtile = {
        enable = true;
        extraPackages =
          p: with p; [
            qtile-extras
          ];
      };

      info.env.wm = "qtile";

      fonts.packages = with pkgs; [
        powerline-fonts
        ubuntu-classic
      ];
    })
  ]);
}
