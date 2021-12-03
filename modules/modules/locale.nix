{ config, options, lib, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.modules.locale;
in
{
  options.modules.locale = {
    keymap = mkOpt "us";
    locale = mkOpt "en_us.UTF-8";
    timezone = mkOpt "America/New_York";
  };

  config = {
    console.keyMap = mkDefault cfg.keymap;
    services.xserver.layout = mkDefault cfg.keymap;

    i18n.defaultLocale = cfg.locale;

    time.timeZone = cfg.timezone;
  };
}
