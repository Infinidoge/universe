{ config, main, ... }: {
  xdg.configFile = {
    "qtile".source = ./qtile;

    "doom" = {
      source = ./doom;
      onChange = ''
        ${config.xdg.configHome}/emacs/bin/doom sync -p
      '';
    };

    "blugon".source = ./blugon;
  };

  home.bindmounts."${main.bud.localFlakeClone}/users/infinidoge/config" = {
    directories = [
      {
        source = "powercord";
        target = ".config/powercord";
      }
    ];
  };
}
