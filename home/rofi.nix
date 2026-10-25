{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    settings = {
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
    theme = "Adapta-Nokto";
  };
}
