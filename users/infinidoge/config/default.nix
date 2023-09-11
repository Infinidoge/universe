{ config, main, lib, pkgs, ... }:
with lib;
{
  xdg.configFile = {
    "doom" = {
      source = ./doom;
      onChange = ''
        echo "[doom] applying doom configuration"
        PATH="${config.home.path}/bin:$PATH" ${config.xdg.configHome}/emacs/bin/doom sync -p
      '';
    };

    "neofetch/config.conf".source = pkgs.substituteAll {
      src = ./neofetch.conf;

      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/TheDarkBug/uwufetch/main/res/nixos.png";
        sha256 = "007q947q2a5c8z9r6cc6mj3idq0ss9zsi9xvij8l8chkjnh8fwn2";
      };
      inherit (main.info) model;
      inherit (main.info.env) wm;
    };
  } // optionalAttrs main.info.graphical {
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
    };

    "blugon".source = ./blugon;
  };
}
