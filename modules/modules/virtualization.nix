{ config, lib, pkgs, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.modules.virtualization;
in
{
  options.modules.virtualization = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [ virt-manager ];
  };
}
