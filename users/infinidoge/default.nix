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

    # FIXME: https://github.com/NixOS/nixpkgs/issues/167785
    home.sessionVariables.MOZ_DISABLE_CONTENT_SANDBOX = "1";

    home.packages = with pkgs; lib.flatten [
      ncdu

      keepassxc

      (ifGraphical [
        speedcrunch

        teams

        libsForQt5.dolphin

        flameshot
        brightnessctl

        sxiv

        libreoffice-fresh

        powercord

        (lib.optional main.modules.hardware.form.desktop qbittorrent)
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
      "docker"
      "libvirtd"
      "minecraft"
      "plugdev"
      "wheel"
    ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAn6zCdIucse6eGvT3hFm7Unw9Qg6E37mAUE7HHL2d58 infinidoge@Infini-DESKTOP"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwo8TGBe91mmkc/QonsXtTBKCJtsAGz3YzphDZlzmaO infinidoge@Infini-FRAMEWORK"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJbNOMgVDM/hJQgzd1ff5uuouDtTLOAgmTt57cNNySif infinidoge@Infini-SERVER"
    ];
  };
}
