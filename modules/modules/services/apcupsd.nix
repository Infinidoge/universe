{ config, options, lib, pkgs, ... }:
with lib;
with lib.our;
let
  cfg = config.modules.services.apcupsd;
  port = 3551;
in
{
  options.modules.services.apcupsd = with types; {
    enable = mkBoolOpt false;
    primary = mkBoolOpt true;
    config = {
      address = mkOpt str "127.0.0.1";
      hooks = mkOpt (attrsOf lines) { };
      battery_level = mkOpt int (if cfg.primary then 35 else 50);
      minutes = mkOpt int (if cfg.primary then 5 else 10);
    };
  };

  config = mkIf cfg.enable {
    services.apcupsd = {
      enable = true;
      configText = ''
        UPSNAME UPS
        UPSCLASS standalone
        UPSMODE disable
        NETSERVER on
        NISPORT ${toString port}

        BATTERYLEVEL ${toString cfg.config.battery_level}
        MINUTES ${toString cfg.config.minutes}
      '' +
      (if cfg.primary then ''
        UPSTYPE usb
        UPSCABLE usb
        NISIP ${cfg.config.address}
      '' else ''
        UPSCABLE ether
        UPSTYPE net
        DEVICE ${cfg.config.address}:${toString port}
        POLLTIME 10
      '');
      hooks = cfg.config.hooks;
    };
    networking.firewall.allowedTCPPorts = mkIf cfg.primary [ port ];
  };
}
