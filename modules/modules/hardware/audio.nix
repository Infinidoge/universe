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
    hardware.pulseaudio.enable = true;
    sound = {
      enable = true;
      mediaKeys = {
        enable = true;
        volumeStep = "2%";
      };
    };

    # HACK Prevents ~/.esd_auth files by disabling the esound protocol module
    #      for pulseaudio, which I likely don't need. Is there a better way?
    hardware.pulseaudio.configFile =
      let inherit (pkgs) runCommand pulseaudio;
        paConfigFile =
          runCommand "disablePulseaudioEsoundModule"
            { buildInputs = [ pulseaudio ]; } ''
            mkdir "$out"
            cp ${pulseaudio}/etc/pulse/default.pa "$out/default.pa"
            sed -i -e 's|load-module module-esound-protocol-unix|# ...|' "$out/default.pa"
          '';
      in
      mkIf config.hardware.pulseaudio.enable
        "${paConfigFile}/default.pa";

    user.extraGroups = [ "audio" ];
  };
}
