{ config, lib, pkgs, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.services.ensure;
in
{
  options.services.ensure = with types; {
    enable = mkBoolOpt true;
    directories = mkOpt (listOf string) [ ];
  };

  config.systemd.services = {
    "ensure-directories" = mkIf (cfg.enable && (length cfg.directories > 0)) {
      description = "Ensures certain directories exist (${concatStringsSep "," cfg.directories})";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      script = "mkdir -p ${concatStringsSep " " cfg.directories}";
    };
  };
}
