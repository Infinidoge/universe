{ config, self, lib, pkgs, suites, profiles, inputs, ... }:
let
  ifGraphical = lib.optionals config.info.graphical;
  ifGraphical' = lib.optional config.info.graphical;
in
{
  imports = lib.flatten [
    (with suites; [ develop ])

    (with profiles; [ virtualization ])
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
          gaming
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
      ])
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

    steam.enable = true;
  };

  modules = {
    locale.fonts = {
      fonts = with pkgs; [
        (nerdfonts.override { fonts = config.modules.locale.fonts.defaults.monospace; })
        dejavu_fonts
      ];

      defaults = {
        monospace = [ "DejaVuSansMono" ];
      };
    };
  };

  user = {
    name = "infinidoge";
    uid = 1000;
    hashedPassword =
      "PASSWORD SET IN THE FUTURE";
    description = "Infinidoge, primary user of the system";
    group = "users";
    isNormalUser = true;
    extraGroups = [ "wheel" "minecraft" "libvirtd" "bluetooth" ];
    shell = pkgs.zsh;
  };
}
