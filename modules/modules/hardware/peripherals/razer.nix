# from https://github.com/hlissner/dotfiles/blob/master/modules/hardware/razer.nix
{ options, config, lib, pkgs, ... }:

with lib;
with lib.hlissner;
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
  };
}
