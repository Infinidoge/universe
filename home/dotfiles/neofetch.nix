{ config, pkgs, ... }:
{

  xdg.configFile."neofetch/config.conf".source = pkgs.replaceVars ./neofetch.conf {
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/ad-oliviero/uwufetch/main/res/nixos.png";
      sha256 = "007q947q2a5c8z9r6cc6mj3idq0ss9zsi9xvij8l8chkjnh8fwn2";
    };
    inherit (config.info) model;
    inherit (config.info.env) wm;
  };
}
