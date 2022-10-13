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
        htop
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
      ncdu

      keepassxc

      (ifGraphical [
        speedcrunch

        brightnessctl

        sxiv

        # libreoffice-fresh

        krita

        discord-canary

        (lib.optional main.modules.hardware.form.desktop qbittorrent)
      ])

      arduino
    ];
  };

  environment.variables.EDITOR =
    let
      pkg = config.home-manager.users.infinidoge.programs.emacs.package;
      editorScript = pkgs.writeScriptBin "emacseditor" ''
        #!${pkgs.runtimeShell}
        if [ -z "$1" ]; then
          exec ${pkg}/bin/emacsclient --create-frame --alternate-editor ${pkg}/bin/emacs
        else
          exec ${pkg}/bin/emacsclient --alternate-editor ${pkg}/bin/emacs "$@"
        fi
      '';
    in
    (lib.mkOverride 900 "${editorScript}/bin/emacseditor");

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

    desktop.wm.qtile.enable = true;

    software.minipro.enable = true;
  };

  user = {
    name = "infinidoge";
    uid = 1000;
    passwordFile = lib.mkIf config.modules.secrets.enable config.secrets.infinidoge-password;
    description = "Infinidoge, primary user of the system";
    group = "users";
    isNormalUser = true;
    extraGroups = [
      "bluetooth"
      "dialout"
      "disk"
      "docker"
      "libvirtd"
      "minecraft"
      "plugdev"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = import ./ssh-keys.nix;
  };
}
