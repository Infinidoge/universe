{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
  };

  home.packages = with pkgs; [
    tor-browser
  ];
}
