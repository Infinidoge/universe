{ config, self, lib, pkgs, ... }: {
  home-manager.users.infinidoge = { suites, profiles, ... }: {
    imports = lib.flattenListSet {
      suites = with suites; [ base ];
      profiles = with profiles; [ ];
      imports = [ ];
    };

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

    emacs
    ripgrep
    coreutils
    cmake
    fd
    fzf
    clang
    mu
    isync
    tetex
    jq
    gnumake
    shellcheck
    nodejs
    nodePackages.prettier

    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
  ];

  environment.shellAliases.ssh = "kitty +kitten ssh";

  programs = {
    vim.defaultEditor = true;

    dconf.enable = true;
    qt5ct.enable = true;

    steam.enable = true;
  };

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      emacs-all-the-icons-fonts
      (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; })
    ];

    fontconfig = {
      enable = true;
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
