{ config, self, lib, pkgs, inputs, ... }:
let
  inherit (lib) flatten optional mkIf;
  ifGraphical = lib.optionals config.info.graphical;
  ifGraphical' = lib.optional config.info.graphical;
in
{
  imports = flatten [
  ];

  home = { config, main, ... }: {
    imports = flatten [
      ./config
    ];

    programs = {
      git = {
        userEmail = "infinidoge@inx.moe";
        userName = "Infinidoge";
      };
      firefox = {
        enable = main.info.graphical;
        package = pkgs.firefox-devedition;
      };
    };

    home.packages = with pkgs; flatten [
      ncdu

      unbted
      packwiz

      toot

      bitwarden-cli

      jmtpfs

      (ifGraphical [
        bitwarden

        speedcrunch

        libreoffice-fresh

        krita

        vimpc
        id3v2
        picard

        (discord-canary.override { withVencord = true; })
        schildichat-desktop

        (optional main.modules.hardware.form.desktop qbittorrent)
      ])
    ];
  };

  environment.variables.EDITOR =
    let
      pkg = config.home-manager.users.infinidoge.programs.emacs.package;
      editorScript = pkgs.writeScriptBin "emacseditor" ''
        #!${pkgs.runtimeShell}
        exec ${pkg}/bin/emacsclient --create-frame "$@"
      '';
    in
    (lib.mkForce "${editorScript}/bin/emacseditor");

  modules = {
    locale.fonts = {
      fonts = with pkgs; [
        (nerdfonts.override { fonts = config.modules.locale.fonts.defaults.monospace ++ [ "NerdFontsSymbolsOnly" ]; })
        dejavu_fonts
        emacs-all-the-icons-fonts
      ];

      defaults = {
        monospace = [ "DejaVuSansMono" ];
      };
    };

    desktop.wm.qtile.enable = true;
  };

  programs = {
    adb.enable = config.info.graphical;
  };

  user = {
    name = "infinidoge";
    uid = 1000;
    hashedPasswordFile = mkIf config.modules.secrets.enable config.secrets.infinidoge-password;
    description = "Infinidoge, primary user of the system";
    group = "users";
    isNormalUser = true;
    extraGroups = [
      "adbusers"
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
