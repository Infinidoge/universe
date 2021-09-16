{ lib, ... }: {
  boot.loader = {
    systemd-boot = {
      enable = lib.mkDefault true;
      editor = false;
      consoleMode = "2";
    };

    efi.canTouchEfiVariables = true;
    timeout = 3;
  };
}
