{ pkgs, lib, config, ... }:
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

      # Compositor to prevent screen tearing
      services.picom = {
        enable = true;
        backend = "glx";
        vSync = true;
      };

      # Automatically attach/detatch connected/disconnected monitors
      services.autorandr = {
        enable = config.info.graphical;
        ignoreLid = true;
        defaultTarget = "horizontal";
        hooks.postswitch = {
          "reload_qtile" = "qtile cmd-obj -o cmd -f reload_config";
        };
      };

      services.xserver.enable = true;

      services.xserver.displayManager = {
        lightdm.enable = true;
        setupCommands = ''
          ${lib.getExe pkgs.autorandr} -c
        '';
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
