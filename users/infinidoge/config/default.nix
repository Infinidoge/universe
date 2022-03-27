{ config, main, lib, ... }:
with lib;
{
  xdg.configFile = {
    "doom" = {
      source = ./doom;
      onChange = ''
        ${config.xdg.configHome}/emacs/bin/doom sync -p
      '';
    };
  } // optionalAttrs main.info.graphical {
    "qtile".source = ./qtile;

    "blugon".source = ./blugon;
  };

  home.bindmounts."${main.bud.localFlakeClone}/users/infinidoge/config" = mkIf main.info.graphical {
    allowOther = true;
    directories = [
      {
        source = "powercord";
        target = ".config/powercord";
      }
    ];
  };
}
