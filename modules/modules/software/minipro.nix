{ config, lib, pkgs, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.modules.software.minipro;
in
{
  options.modules.software.minipro = {
    enable = mkBoolOpt false;
    udev = mkBoolOpt true;
  };
  config = mkIf cfg.enable {
    home.home.packages = [ pkgs.minipro ];
    services.udev.packages = [ pkgs.minipro ];
  };
}
