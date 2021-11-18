{ lib, ... }:
with lib;
{
  boot.loader = {
    systemd-boot = {
      enable = mkDefault true;
      editor = false;
      consoleMode = "2";
    };

    efi.canTouchEfiVariables = true;
    timeout = mkDefault 3;
  };
}
