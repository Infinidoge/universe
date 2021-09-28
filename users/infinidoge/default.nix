{ config, self, lib, pkgs, suites, profiles, ... }@main: {
  imports = lib.our.flattenListSet {
    suites = with suites; [ develop ];
  };

  home-manager.users.infinidoge = { config, suites, profiles, ... }: {
    imports = lib.our.flattenListSet {
      suites = with suites; [ base ];
    };

    programs.git = {
      userEmail = "infinidoge@doge-inc.net";
      userName = "Infinidoge";
    };

    programs = {
      firefox = {
        enable = true;
      };
    };

    home = {
      file = {
        qtile_config = {
          source = ./config/qtile.py;
          target = "${config.xdg.configHome}/qtile/config.py";
        };
      };

      packages = with pkgs; [
        discord-plugged

        hydrus

        neofetch
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    vim
    htop

    ffmpeg
    ntfs3g
    unzip

    gnupg

    libsForQt5.dolphin
    gnome3.adwaita-icon-theme
    adwaita-qt
    lxappearance
  ];

  environment.shellAliases.ssh = "kitty +kitten ssh";

  programs = {
    vim.defaultEditor = true;

    dconf.enable = true;
    qt5ct.enable = true;

    steam.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3"; # "emacs" potential
    };
  };

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      emacs-all-the-icons-fonts
      (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; })
    ];

    fontconfig = {
      enable = lib.mkDefault true;
      defaultFonts = {
        monospace = [ "DejaVuSansMono" ];
        sansSerif = [ "DejaVu Sans" ];
      };
    };
  };

  users.users.infinidoge = {
    uid = 1000;
    hashedPassword =
      "PASSWORD SET IN THE FUTURE";
    description = "Infinidoge";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
}
