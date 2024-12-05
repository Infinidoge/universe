{ main, lib, pkgs, ... }:
lib.mkIf main.universe.media.enable
{
  services = {
    mpris-proxy.enable = true;
    playerctld.enable = true;
    easyeffects.enable = true;
  };

  programs.obs-studio = {
    enable = main.universe.media.enable;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
  };

  home.packages = with pkgs; [
    audacity
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
