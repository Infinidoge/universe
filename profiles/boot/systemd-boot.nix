{ ... }: {
  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;
      consoleMode = "2";
    };

    efi.canTouchEfiVariables = true;
    timeout = 3;
  };
}
