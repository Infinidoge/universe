{ main, config, lib, pkgs, ... }:

{
  config = lib.mkIf main.info.graphical {
    services = {
      mpris-proxy.enable = true;
      playerctld.enable = true;
    };

    home.packages = with pkgs; [
      playerctl
    ];
  };
}
