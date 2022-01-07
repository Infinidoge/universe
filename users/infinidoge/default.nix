{ config, self, lib, pkgs, suites, profiles, inputs, ... }:
let
  ifGraphical = lib.optionals config.info.graphical;
  ifGraphical' = lib.optional config.info.graphical;
in
{
  imports = lib.flatten [
    (with suites; [ develop ])
  ];

  home = { config, main, suites, profiles, ... }: {
    imports = lib.flatten [
      (with suites; [
        base

        (ifGraphical' graphic)
      ])
      (with profiles; [
        pass
        htop
        nnn

        (ifGraphical [
          discord
        ])
      ])

      ./config
    ];

    programs = {
      git = {
        userEmail = "infinidoge@doge-inc.net";
        userName = "Infinidoge";
      };
      firefox = {
        enable = true;
      };
    };

    home.packages = with pkgs; lib.flatten [
      btrfs-progs
      ncdu

      (ifGraphical [
        hydrus

        speedcrunch

        teams

        libsForQt5.dolphin
        gnome.gnome-screenshot

        sxiv

        libreoffice-fresh
      ])

      arduino
      minipro
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      ffmpeg
    ];

    shellAliases = { };

    variables.EDITOR =
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
  };

  programs = {
    dconf.enable = true;
  };

  modules = {
    locale.fonts = {
      fonts = with pkgs; [
        (nerdfonts.override { fonts = config.modules.locale.fonts.defaults.monospace; })
        dejavu_fonts
        emacs-all-the-icons-fonts
      ];

      defaults = {
        monospace = [ "DejaVuSansMono" ];
      };
    };

    software.minipro.enable = true;
  };

  user = {
    name = "infinidoge";
    uid = 1000;
    hashedPassword =
      "PASSWORD SET IN THE FUTURE";
    description = "Infinidoge, primary user of the system";
    group = "users";
    isNormalUser = true;
    extraGroups = [
      "bluetooth"
      "dialout"
      "disk"
      "libvirtd"
      "minecraft"
      "wheel"
      "plugdev"
    ];
    shell = pkgs.zsh;
  };
}
