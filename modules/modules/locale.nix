{ config, options, lib, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.modules.locale;
  opt = options.modules.locale;
in
{
  options.modules.locale = with types; {
    keymap = mkOpt str "us";
    locale = mkOpt str "en_US.UTF-8";
    timezone = mkOpt str "America/New_York";

    fonts = {
      fonts = mkOpt (listOf package) [ ];
      defaults = mkOpt attrs { };
    };
  };

  config = {
    console.keyMap = mkDefault cfg.keymap;
    services.xserver = {
      layout = mkDefault cfg.keymap;
      xkbOptions = "compose:ralt";
    };

    i18n.defaultLocale = cfg.locale;

    time.timeZone = cfg.timezone;

    fonts = {
      fonts = cfg.fonts.fonts;
      fontconfig.defaultFonts = mkAliasDefinitions opt.fonts.defaults;
    };

    console.packages = cfg.fonts.fonts;
  };
}
