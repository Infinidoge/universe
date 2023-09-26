{ config, lib, pkgs, ... }:
with lib;
with lib.our;
let
  cfg = config.modules.services.foldingathome;
in
{
  options.modules.services.foldingathome = with types; {
    enable = mkBoolOpt false;
    user = mkOpt str config.user.name;
    daemonNiceLevel = mkOpt int 10;
    extra = {
      control = mkBoolOpt false;
      viewer = mkBoolOpt false;
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      services.foldingathome = {
        enable = true;
        user = cfg.user;
        daemonNiceLevel = cfg.daemonNiceLevel;
      };

      environment.systemPackages = with pkgs; [
        (mkIf cfg.extra.control pkgs.fahcontrol)
        (mkIf cfg.extra.viewer pkgs.fahviewer)
      ];
    })
  ];
}
