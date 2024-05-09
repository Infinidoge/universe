{ config, self, lib, pkgs, inputs, ... }:
let
  inherit (lib) flatten optional mkIf;
  ifGraphical = lib.optionals config.info.graphical;
  ifGraphical' = lib.optional config.info.graphical;
in
{
  imports = [
  ];

  home = { config, main, ... }: {
    imports = [
      ./config
    ];

    programs = {
      git = {
        userEmail = "infinidoge@inx.moe";
        userName = "Infinidoge";
        extraConfig = {
          gpg.format = "ssh";
          commit.gpgsign = true;
          user.signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        };
      };
      firefox = {
        enable = main.info.graphical;
        package = pkgs.firefox-devedition;
      };
    };

    home.sessionVariables.KEYID = "0x30E7A4C03348641E";

    home.packages = with pkgs; flatten [
      bitwarden-cli
      bsd-finger
      jmtpfs
      ncdu
      packwiz
      peaclock
      toot
      unbted

      (ifGraphical [
        # Tools
        audacity
        bitwarden
        inkscape
        krita
        libreoffice-fresh
        speedcrunch

        # Media
        id3v2
        jellyfin-media-player
        picard
        sonixd

        (discord-canary.override { withVencord = true; withOpenASAR = true; })
        (discord.override { withVencord = true; withOpenASAR = true; })
        cinny-desktop
        schildichat-desktop
        thunderbird
        tor-browser

        (optional main.modules.hardware.form.desktop qbittorrent)
      ])
    ];
  };

  systemd.user.tmpfiles.users.infinidoge.rules = mkIf config.info.graphical [
    "L+ /home/infinidoge/.local/share/jellyfinmediaplayer/scripts/mpris.so - - - - ${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so"
  ];

  #environment.variables.EDITOR =
  #  let
  #    pkg = config.home-manager.users.infinidoge.programs.emacs.package;
  #    editorScript = pkgs.writeScriptBin "emacseditor" ''
  #      #!${pkgs.runtimeShell}
  #      exec ${pkg}/bin/emacsclient --create-frame "$@"
  #    '';
  #  in
  #  (lib.mkForce "${editorScript}/bin/emacseditor");

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
      "borg"
      "dialout"
      "disk"
      "docker"
      "factorio"
      "forgejo"
      "jellyfin"
      "libvirtd"
      "minecraft"
      "nginx"
      "plugdev"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = import ./ssh-keys.nix;
  };
}
