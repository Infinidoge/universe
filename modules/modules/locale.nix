{ config, options, lib, ... }:
with lib;
with lib.our;
let
  cfg = config.modules.locale;
  opt = options.modules.locale;
in
{
  options.modules.locale = with types; {
    keymap = mkOpt str "us";
    locale = mkOpt str "en_US.UTF-8";
    timezone = mkOpt (nullOr str) "America/New_York";

    fonts = {
      fonts = mkOpt (listOf package) [ ];
      defaults = mkOpt attrs { };
    };
  };

  config = {
    console.keyMap = mkDefault cfg.keymap;
    services.xserver.xkb = {
      layout = mkDefault cfg.keymap;
      options = "compose:ralt";
    };
    services.libinput.enable = true;

    i18n.defaultLocale = cfg.locale;

    time.timeZone = mkIf (cfg.timezone != null) cfg.timezone;

    services.automatic-timezoned.enable = config.modules.hardware.form.laptop;

    fonts = {
      packages = cfg.fonts.fonts;
      fontconfig.defaultFonts = mkAliasDefinitions opt.fonts.defaults;
    };

    console.packages = cfg.fonts.fonts;
  };
}
