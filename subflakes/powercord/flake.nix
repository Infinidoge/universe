{
  description = "The powercord plugins, themes, and configuration that make up Infinidoge's setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    fup.url = "github:gytis-ivaskevicius/flake-utils-plus";

    powercord = { url = "github:powercord-org/powercord"; flake = false; };
    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
    powercord-overlay.inputs.nixpkgs.follows = "nixpkgs";
    powercord-overlay.inputs.powercord.follows = "powercord";

    # --- Plugins
    discord-Custom-Volume-Range = { url = "github:PandaDriver156/Custom-Volume-Range"; flake = false; };
    discord-In-app-notifs = { url = "github:BenSegal855/In-app-notifs"; flake = false; };
    discord-NSFW-tags = { url = "github:E-boi/NSFW-tags"; flake = false; };
    discord-PowercordTwemojiEverywhere = { url = "github:VenPlugs/PowercordTwemojiEverywhere"; flake = false; };
    discord-Quick-Bot-Invite = { url = "github:A-Trash-Coder/Quick-Bot-Invite"; flake = false; };
    discord-Quick-Channel-Mute = { url = "github:A-Trash-Coder/Quick-Channel-Mute"; flake = false; };
    discord-SnowflakeInfo = { url = "github:NurMarvin/SnowflakeInfo"; flake = false; };
    discord-Unindent = { url = "github:VenPlugs/Unindent"; flake = false; };
    discord-badges-everywhere = { url = "github:powercord-community/badges-everywhere"; flake = false; };
    discord-better-connections = { url = "github:AAGaming00/better-connections"; flake = false; };
    discord-better-folders = { url = "github:Juby210/better-folders"; flake = false; };
    discord-better-replies = { url = "github:cyyynthia/better-replies"; flake = false; };
    discord-better-settings = { url = "github:mr-miner1/better-settings"; flake = false; };
    discord-better-status-indicators = { url = "github:GriefMoDz/better-status-indicators"; flake = false; };
    discord-better-threads = { url = "github:NurMarvin/better-threads"; flake = false; };
    discord-betterinvites = { url = "github:12944qwerty/betterinvites"; flake = false; };
    discord-block-messages = { url = "github:cyyynthia/block-messages"; flake = false; };
    discord-channel-typing = { url = "github:powercord-community/channel-typing"; flake = false; };
    discord-copy-avatar-url = { url = "github:21Joakim/copy-avatar-url"; flake = false; };
    discord-copy-mentions = { url = "github:tealingg/copy-mentions"; flake = false; };
    discord-copy-raw-message = { url = "github:mic0ishere/copy-raw-message"; flake = false; };
    discord-copy-role-color = { url = "github:Antonio32A/copy-role-color"; flake = false; };
    discord-css-toggler = { url = "github:12944qwerty/css-toggler"; flake = false; };
    discord-custom-timestamps = { url = "github:TaiAurori/custom-timestamps"; flake = false; };
    discord-cutecord = { url = "github:powercord-community/cutecord"; flake = false; };
    discord-discord-status = { url = "github:KableKo/discord-status"; flake = false; };
    discord-dm-typing-indicator = { url = "github:zt64/dm-typing-indicator"; flake = false; };
    discord-guild-profile = { url = "github:NurMarvin/guild-profile"; flake = false; };
    discord-kaomoji = { url = "github:davidcralph/kaomoji"; flake = false; };
    discord-mention-cache-fix = { url = "github:asportnoy/mention-cache-fix"; flake = false; };
    discord-message-link-embed = { url = "github:Juby210/message-link-embed"; flake = false; };
    discord-online-friends-count = { url = "github:GriefMoDz/online-friends-count"; flake = false; };
    discord-permission-viewer = { url = "github:powercord-community/permission-viewer"; flake = false; };
    discord-powercord-LinkChannels = { url = "github:E-boi/powercord-LinkChannels"; flake = false; };
    discord-powercord-message-tooltips = { url = "github:lorencerri/powercord-message-tooltips"; flake = false; };
    discord-powercord-mute-folder = { url = "github:notsapinho/powercord-mute-folder"; flake = false; };
    discord-powercord-ownertags = { url = "github:Puyodead1/powercord-ownertag"; flake = false; };
    discord-powercord-pindms = { url = "github:Bricklou/powercord-pindms"; flake = false; };
    discord-powercord-reverse-image-search = { url = "github:lorencerri/powercord-reverse-image-search"; flake = false; };
    discord-pronoundb-powercord = { url = "github:cyyynthia/pronoundb-powercord"; flake = false; };
    discord-quick-delete-pc = { url = "github:the-cord-plug/quick-delete-pc"; flake = false; };
    discord-reddit-parser = { url = "github:Rodentman87/reddit-parser"; flake = false; };
    discord-relationship-notifier = { url = "github:Twizzer/relationship-notifier"; flake = false; };
    discord-remove-invite-from-user-context-menu = { url = "github:SebbyLaw/remove-invite-from-user-context-menu"; flake = false; };
    discord-replace-timestamps-pc = { url = "github:SpoonMcForky/replace-timestamps-pc"; flake = false; };
    discord-report-messages = { url = "github:12944qwerty/report-messages"; flake = false; };
    discord-rolecolor-everywhere = { url = "github:powercord-community/rolecolor-everywhere"; flake = false; };
    discord-scrollable-autocomplete = { url = "github:GriefMoDz/scrollable-autocomplete"; flake = false; };
    discord-send-timestamps = { url = "github:12944qwerty/send-timestamps"; flake = false; };
    discord-server-count = { url = "github:TheShadowGamer/Server-Count"; flake = false; };
    discord-showAllMessageButtons = { url = "github:12944qwerty/showAllMessageButtons"; flake = false; };
    discord-smart-typers = { url = "github:GriefMoDz/smart-typers"; flake = false; };
    discord-total-members = { url = "github:cyyynthia/total-members"; flake = false; };
    discord-user-birthdays = { url = "github:GriefMoDz/user-birthdays"; flake = false; };
    discord-user-details = { url = "github:Juby210/user-details"; flake = false; };
    discord-userid-info = { url = "github:webtax-gh/userid-info"; flake = false; };
    discord-vcTimer = { url = "github:RazerMoon/vcTimer"; flake = false; };
    discord-voice-chat-utilities = { url = "github:dutake/voice-chat-utilities"; flake = false; };
    discord-voice-user-count = { url = "github:tuanbinhtran/voice-user-count"; flake = false; };
    discord-webhook-tag = { url = "github:BenSegal855/webhook-tag"; flake = false; };

    # --- Themes ---
    discord-Discolored = { url = "github:NYRI4/Discolored"; flake = false; };
  };

  outputs = inputs@{ self, nixpkgs, fup, powercord-overlay, ... }:
    let
      patches = ./patches;
    in
    fup.lib.mkFlake rec {

      inherit self inputs;

      channelsConfig = { allowUnfree = true; };
      sharedOverlays = [ powercord-overlay.overlay ];

      overlay = final: prev: { inherit (self.packages.x86_64-linux) powercord; };

      outputsBuilder = channels: rec {
        defaultPackage = packages.powercord;
        packages = with channels.nixpkgs; {
          powercord = (discord-plugged.override {
            plugins = with inputs; [
              discord-Custom-Volume-Range
              discord-In-app-notifs
              discord-NSFW-tags
              discord-PowercordTwemojiEverywhere
              discord-Quick-Bot-Invite
              discord-Quick-Channel-Mute
              discord-SnowflakeInfo
              discord-Unindent
              discord-badges-everywhere
              discord-better-connections
              discord-better-folders
              discord-better-replies
              discord-better-settings
              # discord-better-status-indicators # FIXME: crashes on loading avatars
              discord-better-threads
              discord-betterinvites
              discord-block-messages
              discord-channel-typing
              discord-copy-avatar-url
              discord-copy-mentions
              discord-copy-raw-message
              discord-copy-role-color
              (applyPatches {
                src = discord-css-toggler;
                patches = [ "${patches}/css-toggler.patch" ];
                name = "discord-css-toggler";
              })
              discord-custom-timestamps
              discord-cutecord
              discord-discord-status
              discord-dm-typing-indicator
              discord-guild-profile
              discord-kaomoji
              discord-mention-cache-fix
              discord-message-link-embed
              discord-online-friends-count
              # discord-permission-viewer # FIXME: https://github.com/powercord-community/permission-viewer/issues/20
              discord-powercord-LinkChannels
              discord-powercord-message-tooltips
              discord-powercord-mute-folder
              discord-powercord-ownertags
              discord-powercord-pindms
              discord-powercord-reverse-image-search
              discord-pronoundb-powercord
              discord-quick-delete-pc
              discord-reddit-parser
              discord-relationship-notifier
              discord-remove-invite-from-user-context-menu
              discord-replace-timestamps-pc
              discord-report-messages
              discord-rolecolor-everywhere
              # discord-scrollable-autocomplete
              # discord-send-timestamps
              # discord-server-count
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
            themes = with inputs; [
              discord-Discolored
            ];
          });
        };
      };

    };
}
