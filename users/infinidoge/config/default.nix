{ config, ... }: {
  xdg.configFile = {
    "qtile".source = ./qtile;

    "doom" = {
      source = ./doom;
      onChange = ''
        ${config.xdg.configHome}/emacs/bin/doom sync -p
      '';
    };

    "blugon".source = ./blugon;

    "powercord".source = ./powercord;
  };
}
