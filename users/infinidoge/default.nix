{ config, self, lib, pkgs, suites, profiles, inputs, ... }: {
  imports = lib.lists.flatten [
    (with suites; [ develop ])

    (with profiles; [ virtualization ])
  ];

  home-manager.users.infinidoge = { config, suites, profiles, ... }: {
    imports = lib.lists.flatten [
      (with suites; [ base ])
      (with profiles; [
        pass
        discord
        gaming

        themeing
      ])
    ];

    programs.git = {
      userEmail = "infinidoge@doge-inc.net";
      userName = "Infinidoge";
    };

    programs = {
      firefox = {
        enable = true;
      };
    };

    xdg.configFile = {
      "qtile".source = ./config/qtile;
      "doom" = {
        source = ./config/doom;
        onChange = ''
          ${config.xdg.configHome}/emacs/bin/doom sync -p
        '';
      };
      "blugon".source = ./config/blugon;
    };

    home.packages = with pkgs; [
      hydrus

      speedcrunch

      teams

      libsForQt5.dolphin
      gnome.gnome-screenshot

      sxiv
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      wget
      vim

      ffmpeg
      ntfs3g
      unzip
    ];

    shellAliases = {
      ssh = "kitty +kitten ssh";
      lsdisk = "lsblk -o name,size,mountpoint,fstype,label,uuid,fsavail,fsuse%";
    };
  };

  programs = {
    vim.defaultEditor = true;

    dconf.enable = true;

    steam.enable = true;
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
    extraGroups = [ "wheel" "minecraft" "libvirtd" ];
    shell = pkgs.zsh;
  };
}
