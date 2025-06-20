{
  config,
  main,
  lib,
  pkgs,
  ...
}:
with lib;
{
  xdg.configFile =
    {
      "neofetch/config.conf".source = pkgs.replaceVars ./neofetch.conf {
        image = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/ad-oliviero/uwufetch/main/res/nixos.png";
          sha256 = "007q947q2a5c8z9r6cc6mj3idq0ss9zsi9xvij8l8chkjnh8fwn2";
        };
        inherit (main.info) model;
        inherit (main.info.env) wm;
      };

      "black".text = ''
        [tool.black]
        line-length = 120
        target-version = ["py310"]
      '';
    }
    // optionalAttrs main.info.graphical {
      "qtile".source = pkgs.substituteSubset {
        src = ./qtile;
        files = [ "config.py" ];

        wallpaper = pkgs.fetchurl {
          name = "BotanWallpaper.jpg";
          # Source: https://www.pixiv.net/en/artworks/86093828
          url = "https://safebooru.org//images/3159/6c2d22b1fcac19a679de61f713c56503bca5aad9.jpg";
          sha256 = "sha256-3oVx9k+IN8GI8EWx3kPiQWdPGSO645abrEIL8C6sNq8=";
        };
        wallpaper_mode = "fill";
        firefox = config.programs.firefox.package.meta.mainProgram;
        locker = main.common.wm.locker.meta.mainProgram;
      };
    };
}
