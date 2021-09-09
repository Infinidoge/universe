{ suites, profiles, pkgs, ... }: {
  imports = suites.graphic
    ++ [ ./hardware-configuration.nix ]
    ++ (with profiles; [
    networking.wireless
    hardware.sound
    graphical.nvidia
    # peripherals.printing
  ]);

  system.stateVersion = "21.05";

  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;
      consoleMode = "2";
    };

    efi.canTouchEfiVariables = true;
    timeout = 3;
  };

  time.timeZone = "America/New_York";

  networking = {
    interfaces = {
      # Enable DHCP per interface
      eth0.useDHCP = true;
      wlp41s0.useDHCP = true;
    };

    wireless.interfaces = [ "wlp41s0" ];
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    earlySetup = true;
    packages = [ ];
  };
  services.kmscon.enable = true;


}
