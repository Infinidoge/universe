{ main, config, lib, pkgs, ... }:

{
  config = lib.mkIf main.info.graphical {
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
      playerctld.enable = true;
    };

    home.packages = with pkgs; [
      playerctl
    ];
  };
}
