{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.our;
let
  cfg = config.modules.hardware.peripherals.yubikey;
in
{
  options.modules.hardware.peripherals.yubikey = {
    enable = mkBoolOpt false;
  };
  config = mkIf cfg.enable {
    home.home.packages = with pkgs; [
      yubikey-manager
      yubikey-personalization
      # yubikey-personalization-gui # Archived upstream
      yubico-piv-tool
      yubioath-flutter
    ];
    services.udev.packages = [ pkgs.yubikey-personalization ];
    services.pcscd.enable = true;
  };
}
