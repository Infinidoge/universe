{ config, lib, pkgs, ... }:

with lib;
with lib.our;
let
  cfg = config.modules.hardware.audio;
in
{
  options.modules.hardware.audio = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

    environment.systemPackages = with pkgs; [
      easyeffects
    ];

    security.rtkit.enable = true;

    persist.directories = [
      "/var/lib/alsa"
    ];
  };
}
