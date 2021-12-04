{ config, options, lib, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.modules.locale;
in
{
  options.modules.locale = with types; {
    keymap = mkOpt str "us";
    locale = mkOpt str "en_us.UTF-8";
    timezone = mkOpt str "America/New_York";

    fonts = {
      fonts = mkOpt (listOf package) [ ];
      defaults = {
        serif = mkOpt (listOf str) "DejaVu Serif";
        emoji = mkOpt (listOf str) "Noto Color Emoji";
        monospace = mkOpt (listOf str) "DejaVu Sans Mono";
        sansSerif = mkOpt (listOf str) "DejaVu Sans";
      };
    };
  };

  config = {
    console.keyMap = mkDefault cfg.keymap;
    services.xserver.layout = mkDefault cfg.keymap;

    i18n.defaultLocale = cfg.locale;

    time.timeZone = cfg.timezone;

    fonts.fontconfig.defaultFonts = mkAliasDefinitions options.defaults;

    console.packages = cfg.fonts.fonts;
  };
}
