{ pkgs, ... }: {
  programs.rofi = {
    enable = true;
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
