# Created by hlissner: https://github.com/hlissner/dotfiles/blob/master/modules/hardware/audio.nix
{ options, config, lib, pkgs, ... }:

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
    sound.enable = true;

    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

    persist.directories = [
      "/var/lib/alsa"
    ];
  };
}
