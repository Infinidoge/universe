{ config, self, lib, pkgs, ... }: {
  home-manager.users.infinidoge = { suites, profiles, ... }: {
    imports =
      (with suites; lib.lists.flatten [ base ])
      ++ (with profiles; [ ])
      ++ [ ];

    home.packages = with pkgs; [
      discord-plugged

      hydrus

      firefox

      neofetch
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
    vim
    htop

    ffmpeg
    ntfs3g
    unzip


    libsForQt5.dolphin
    gnome3.adwaita-icon-theme
    adwaita-qt
    lxappearance

    pinentry-curses
  ];

  environment.shellAliases.ssh = "kitty +kitten ssh";

  programs = {
    vim.defaultEditor = true;

    dconf.enable = true;
    qt5ct.enable = true;
  };

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; })
    ];

    fontconfig.defaultFonts = {
      monospace = [ "DejaVuSansMono" ];
      sansSerif = [ "DejaVu Sans" ];
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
