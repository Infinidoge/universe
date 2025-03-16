{
  config,
  common,
  secrets,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) flatten optional mkIf;
  ifGraphical = lib.optionals config.info.graphical;
  ifGraphical' = lib.optional config.info.graphical;
in
{
  imports = [
  ];

  home =
    { config, main, ... }:
    {
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

      services.unison = {
        enable = true;
        pairs = {
          "PrismLauncher" = mkIf (main.networking.hostName != "Infini-DL360") {
            roots = [
              "/home/infinidoge/.local/share/PrismLauncher"
              "ssh://inx.moe/sync/PrismLauncher"
            ];
            commandOptions = {
              ignore = [
                "BelowPath cache"
              ];
            };
          };
        };
      };

      home.sessionVariables = {
        KEYID = "0x30E7A4C03348641E";
        POP_SMTP_HOST = common.email.smtp.address;
        POP_SMTP_PORT = common.email.smtp.STARTTLS;
        POP_SMTP_USERNAME = common.email.withUser "infinidoge";
        POP_SMTP_PASSWORD = "$(cat ${secrets.smtp-personal})";
        UNISON = "$HOME/.local/state/unison";
      };

      home.packages =
        with pkgs;
        flatten [
          bitwarden-cli
          bsd-finger
          jmtpfs
          ncdu
          peaclock
          pop
          unison

          (lib.optionals (!main.universe.minimal.enable) [
            packwiz
            toot
          ])

          (ifGraphical [
            speedcrunch
            (discord-canary.override {
              withVencord = true;
              withOpenASAR = true;
              withTTS = false;
            })
          ])

          (lib.optionals (!main.universe.minimal.enable && main.info.graphical) [
            (discord.override {
              withVencord = true;
              withOpenASAR = true;
              withTTS = false;
            })
            schildichat-desktop
            signal-desktop
            teams-for-linux
            thunderbird
            tor-browser
            bitwarden
            qbittorrent
            sqlitebrowser
          ])
        ];
    };

  systemd.user.tmpfiles.users.infinidoge.rules = mkIf config.universe.media.enable [
    "L+ /home/infinidoge/.local/share/jellyfinmediaplayer/scripts/mpris.so - - - - ${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so"
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.symbols-only
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

  age.rekey.masterIdentities = [
    ./keys/primary_age.pub
    ./keys/backup_age.pub
  ];

  age.secrets = {
    password-infinidoge.rekeyFile = ./password.age;
    smtp-personal.rekeyFile = ./smtp-personal.age;
    smtp-personal.owner = "infinidoge";
  };

  user.hashedPasswordFile = mkIf config.modules.secrets.enable secrets.password-infinidoge;

  user = {
    name = "infinidoge";
    uid = 1000;
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
      "smtp"
      "systemd-journal"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = import ./ssh-keys.nix;
  };
}
