{ config, self, lib, pkgs, suites, profiles, inputs, ... }: {
  imports = lib.flatten [
    (with suites; [ develop ])

    (with profiles; [ virtualization ])
  ];

  home-manager.users.infinidoge = { config, main, suites, profiles, ... }: {
    imports = lib.flatten [
      (with suites; [
        base

        (lib.optional main.services.xserver.enable graphic)
      ])
      (with profiles; [
        pass

        (lib.optionals main.services.xserver.enable [
          discord
          gaming
        ])
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

    home.packages = with pkgs; lib.flatten [
      btrfs-progs

      (lib.optionals main.services.xserver.enable [
        hydrus

        speedcrunch

        teams

        libsForQt5.dolphin
        gnome.gnome-screenshot

        sxiv
      ])
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

  environment.variables.EDITOR =
    let
      editorScript = pkgs.writeScriptBin "emacseditor" ''
        #!${pkgs.runtimeShell}
        if [ -z "$1" ]; then
          exec ${pkgs.emacs}/bin/emacsclient --create-frame --alternate-editor ${pkgs.emacs}/bin/emacs
        else
          exec ${pkgs.emacs}/bin/emacsclient --alternate-editor ${pkgs.emacs}/bin/emacs "$@"
        fi
      '';
    in
    (lib.mkOverride 900 "${editorScript}/bin/emacseditor");

  programs = {
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
    extraGroups = [ "wheel" "minecraft" "libvirtd" "bluetooth" ];
    shell = pkgs.zsh;
  };
}
