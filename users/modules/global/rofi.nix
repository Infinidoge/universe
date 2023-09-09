{ main, pkgs, ... }: {
  programs.rofi = {
    enable = main.info.graphical;
    extraConfig = {
      modi = builtins.concatStringsSep "," [
        "window"
        "run"
        "ssh"
        "windowcd"
        "drun"
        "combi"
        "keys"
      ];
    };
    plugins = with pkgs; [ ];
    pass.enable = true;
    theme = "Adapta-Nokto";
  };
}
