{ config, lib, pkgs, ... }:
with lib;
with lib.our;
let
  cfg = config.modules.software.minipro;
in
{
  options.modules.software.minipro = {
    enable = mkBoolOpt false;
  };
  config = mkIf cfg.enable {
    home.home.packages = [ pkgs.minipro ];
    services.udev.packages = [ pkgs.minipro ];
  };
}
