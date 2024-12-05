{ config, lib, pkgs, ... }:
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
      peaclock
      pop

      (lib.optionals (!main.universe.minimal.enable) [
        packwiz
        toot
      ])

      (ifGraphical [
        speedcrunch
        (discord-canary.override { withVencord = true; withOpenASAR = true; withTTS = false; })
      ])

      (lib.optionals (!main.universe.minimal.enable && main.info.graphical) [
        (discord.override { withVencord = true; withOpenASAR = true; withTTS = false; })
        schildichat-desktop
        teams-for-linux
        thunderbird
        tor-browser
        bitwarden
        qbittorrent
      ])
    ];
  };

  systemd.user.tmpfiles.users.infinidoge.rules = mkIf config.universe.media.enable [
    "L+ /home/infinidoge/.local/share/jellyfinmediaplayer/scripts/mpris.so - - - - ${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so"
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [ "DejaVuSansMono" "NerdFontsSymbolsOnly" ];
    })
    dejavu_fonts
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "DejaVuSansMono" ];
  };


  modules = {
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
      "incoming"
      "jellyfin"
      "libvirtd"
      "minecraft"
      "nginx"
      "plugdev"
      "systemd-journal"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = import ./ssh-keys.nix;
  };
}
