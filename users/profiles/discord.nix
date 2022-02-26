{ pkgs, inputs, patches, ... }: {
  home.packages = with pkgs; [
    (discord-plugged.override {
      plugins = with inputs; [
        discord-Custom-Volume-Range
        discord-In-app-notifs
        discord-NSFW-tags
        discord-PowerAliases
        discord-PowercordTwemojiEverywhere
        discord-Quick-Bot-Invite
        discord-Quick-Channel-Mute
        # discord-Scalable-Discord
        # discord-Send-Message-with-Webhook
        discord-SnowflakeInfo
        discord-Unindent
        discord-badges-everywhere
        discord-better-connections
        discord-better-folders
        discord-better-replies
        discord-better-settings
        discord-better-status-indicators
        discord-better-threads
        discord-betterinvites
        discord-block-messages
        # discord-channel-locker
        discord-channel-typing
        discord-copy-avatar-url
        discord-copy-mentions
        discord-copy-raw-message
        discord-copy-role-color
        (pkgs.applyPatches {
          src = inputs.discord-css-toggler;
          patches = [
            "${patches}/css-toggler.patch"
          ];
          name = "discord-css-toggler";
        })
        discord-custom-timestamps
        discord-cutecord
        discord-discord-status
        discord-dm-typing-indicator
        discord-guild-profile
        discord-inbox-unread-count
        discord-kaomoji
        discord-mention-cache-fix
        discord-message-link-embed
        # discord-multitask
        discord-online-friends-count
        discord-permission-viewer
        discord-powercord-LinkChannels
        discord-powercord-message-tooltips
        discord-powercord-mute-folder
        discord-powercord-ownertags
        discord-powercord-pindms
        discord-powercord-ppl-moe
        discord-powercord-reverse-image-search
        discord-pronoundb-powercord
        discord-quick-Status
        discord-quick-delete-pc
        discord-reddit-parser
        discord-relationship-notifier
        discord-remove-invite-from-user-context-menu
        discord-replace-timestamps-pc
        discord-report-messages
        discord-rolecolor-everywhere
        discord-scrollable-autocomplete
        discord-send-timestamps
        discord-server-count
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
        # discord-amoled-cord
      ];
    })
  ];
}
