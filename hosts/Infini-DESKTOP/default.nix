{ suites, ... }: {
  imports = suites.base ++ [ ./hardware-configuration.nix ];

  system.stateVersion = "21.05";

  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;
      consoleMode = "2";
    };

    efi.canTouchEfiVariables = true;
    timeout = 5;
  };

  time.timeZone = "America/New_York";

  networking = {
    useDHCP = false; # Explicitly disable broad DHCP
    interfaces = {
      # Enable DHCP per interface
      eth0.useDHCP = true;
      wlp41s0.useDHCP = true;
    };

    wireless = {
      enable = true; # Enable wireless
      interfaces = [ "wlp41s0" ];

      networks = {
        Mashtun = {
          pskRaw =
            "1ccf3e0cc08700f2484e4a0e202836898cc8c084b7e05d6798bf0a7ba9bbc306";
        };
      };
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    earlySetup = true;
    packages = [ ];
    colors = [
      # Solarized Dark Theme
      "002b36"
      "dc322f"
      "859900"
      "b58900"
      "268bd2"
      "6c71c4"
      "2aa198"
      "93a1a1"
      "657b83"
      "dc322f"
      "859900"
      "b58900"
      "268bd2"
      "6c71c4"
      "2aa198"
      "93a1a1"
    ];
  };
  services.kmscon.enable = true;

  services.gvfs.enable = true; # MTP support

  services.xserver = {
    # Enable X11 Windowing and Qtile Window Manager
    enable = true;
    windowManager.qtile.enable = true;

    # Configure X11 keymap
    layout = "us";

    videoDrivers = [ "nvidia" ];
  };

  hardware.nvidia.modesetting.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cnijfilter2
      gutenprintBin
      cupsBjnp
      cups-bjnp
      canon-cups-ufr2
      carps-cups
      cnijfilter_2_80
      cnijfilter_4_00
    ];
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
