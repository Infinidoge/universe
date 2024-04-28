{ options, config, lib, pkgs, ... }:

with lib;
with lib.our;
let cfg = config.modules.hardware.peripherals.razer;
in
{
  options.modules.hardware.peripherals.razer = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.openrazer = {
      enable = true;
      users = [ config.user.name ];
    };

    user.extraGroups = [ "plugdev" ];

    home.home.packages = with pkgs; [ razergenie ]; # TODO replace with polychromatic
  };
}
