{ config, lib, pkgs, inputs, ... }:
with lib;
with lib.our;
with lib.hlissner;
let
  cfg = config.modules.hardware.backlight;
in
{
  options.modules.hardware.backlight = with types; {
    enable = mkBoolOpt false;
    initialValue = mkOpt str "50%";
    initialCommand = mkOpt str "${getMainProgram pkgs.brightnessctl} set ${cfg.initialValue} --class=backlight";
  };

  config.systemd.services = mkIf cfg.enable {
    "set-initial-backlight" = {
      description = "Sets the initial backlight status on startup";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      script = cfg.initialCommand;
    };
  };
}
