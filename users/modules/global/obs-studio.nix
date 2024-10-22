{ main, pkgs, ... }:

{
  programs.obs-studio = {
    enable = main.info.graphical;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
  };
}
