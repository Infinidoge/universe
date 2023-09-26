{ config, lib, pkgs, ... }:
with lib;
with lib.our;
let
  cfg = config.modules.hardware.peripherals.printing;
in
{
  options.modules.hardware.peripherals.printing = with types; {
    enable = mkBoolOpt false;
    drivers = mkOpt (functionTo listOf package) (pkgs: [ ]);
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = cfg.drivers pkgs;
    };
  };
}
