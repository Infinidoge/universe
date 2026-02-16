{ common, ... }:
let
  cfg = common.locale;
in
{
  common.locale = {
    keymap = "us";
    locale = "en_US.UTF-8";
    timezone = "America/New_York";
  };

  console.keyMap = cfg.keymap;
  services.xserver.xkb = {
    layout = cfg.keymap;
    options = "compose:ralt,caps:hyper";
  };

  i18n.defaultLocale = cfg.locale;

  time.timeZone = cfg.timezone;
}
