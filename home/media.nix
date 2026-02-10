{ pkgs, ... }:
{
  services = {
    mpris-proxy.enable = true;
    playerctld.enable = true;
    easyeffects.enable = true;
  };

  home.packages = with pkgs; [
    audacity
    bespokesynth
    feishin
    id3v2
    imv
    inkscape
    jellyfin-media-player
    krita
    libreoffice-fresh
    picard
    playerctl
    simulide
  ];
}
