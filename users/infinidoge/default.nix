{ config, self, lib, pkgs, suites, profiles, inputs, ... }@main: {
  imports = lib.our.flattenListSet {
    suites = with suites; [ develop ];
  };

  home-manager.users.infinidoge = { config, suites, profiles, ... }: {
    imports = lib.our.flattenListSet {
      suites = with suites; [ base ];
    };

    programs.git = {
      userEmail = "infinidoge@doge-inc.net";
      userName = "Infinidoge";
    };

    programs = {
      firefox = {
        enable = true;
      };
    };

    home = {
      file = {
        qtile_config = {
          source = ./config/qtile;
          target = "${config.xdg.configHome}/qtile";
        };

        doom_config = {
          source = ./config/doom;
          target = "${config.xdg.configHome}/doom";
        };
      };

      packages = with pkgs; [
        (discord-plugged.override {
          plugins = with inputs; [
            discord-Better-Friends-List
            discord-Custom-Volume-Range
            discord-Do-Not-Slowmode-Me
            discord-In-app-notifs
            discord-NSFW-tags
            discord-Password-System
            discord-PowerAliases
            discord-PowercordTwemojiEverywhere
            discord-Quick-Bot-Invite
            discord-Quick-Channel-Mute
            discord-Scalable-Discord
            discord-Send-Message-with-Webhook
            discord-SnowflakeInfo
            discord-Unindent
            discord-badges-everywhere
            discord-better-connections
            discord-better-folders
            discord-better-replies
            discord-better-settings
            discord-better-status-indicators
            discord-better-threads
            discord-block-messages
            discord-channel-locker
            discord-channel-typing
            discord-copy-mentions
            discord-copy-raw-message
            discord-copy-role-color
            discord-custom-timestamps
            discord-cutecord
            discord-discord-status
            discord-dm-typing-indicator
            discord-guild-profile
            discord-inbox-unread-count
            discord-message-link-embed
            discord-multitask
            discord-online-friends-count
            discord-permission-viewer
            discord-powercord-LinkChannels
            discord-powercord-message-tooltips
            discord-powercord-mute-folder
            discord-powercord-ownertags
            discord-powercord-ppl-moe
            discord-powercord-reverse-image-search
            discord-pronoundb-powercord
            discord-quick-Status
            discord-quick-delete-pc
            discord-quick-reply
            discord-quickstar
            discord-reddit-parser
            discord-relationship-notifier
            discord-remove-invite-from-user-context-menu
            discord-report-messages
            discord-rich-quotes
            discord-rolecolor-everywhere
            discord-scrollable-autocomplete
            discord-send-timestamps
            discord-showAllMessageButtons
            discord-smart-typers
            discord-total-members
            discord-user-birthdays
            discord-user-details
            discord-userid-info
            discord-vcTimer
            discord-voice-chat-utilities
            discord-voice-user-count
            discord-webhook-tag
          ];
        })

        hydrus

        speedcrunch

        teams

        libsForQt5.dolphin
        gnome3.adwaita-icon-theme
        adwaita-qt
        lxappearance
      ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      wget
      vim
      htop

      ffmpeg
      ntfs3g
      unzip

      gnupg
    ];

    shellAliases = {
      ssh = "kitty +kitten ssh";
      lsdisk = "lsblk -o name,size,mountpoints,fstype,label,uuid,fsavail,fsuse%";
    };
  };

  programs = {
    vim.defaultEditor = true;

    dconf.enable = true;
    qt5ct.enable = true;

    steam.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3"; # "emacs" potential
    };
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
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
}
