# Created by hlissner: https://github.com/hlissner/dotfiles/blob/master/modules/hardware/audio.nix
{ options, config, lib, pkgs, ... }:

with lib;
with lib.hlissner;
let
  cfg = config.modules.hardware.audio;
in
{
  options.modules.hardware.audio = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    sound = {
      enable = true;
      mediaKeys = {
        enable = true;
        volumeStep = "2%";
      };
    };

    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };
  };
}
