{ config, options, lib, pkgs, ... }:
with lib;
with lib.our;
let
  # Since it is aliased
  cfg = config.services.fprintd;
in
{
  options.modules.hardware.peripherals.fprint-sensor = mkOpt types.attrs { };

  config.services.fprintd = mkAliasDefinitions options.modules.hardware.peripherals.fprint-sensor;

  config.persist.directories = mkIf cfg.enable [
    "/var/lib/fprint"
  ];
}
