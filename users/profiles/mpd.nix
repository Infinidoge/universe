{ config, lib, pkgs, ... }:

{
  services = {
    mpd = {
      enable = true;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire Sound Server"
        }
      '';
    };
    mpd-mpris.enable = true;
    mpris-proxy.enable = true;
  };

  home.packages = with pkgs; [
    playerctl
  ];
}
