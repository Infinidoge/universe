{
  description = "A highly structured configuration database.";

  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substituters = "https://nrdxp.cachix.org https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys = "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs = {
    # --- DevOS Flake Inputs
    verystable.url = "github:nixos/nixpkgs/nixos-21.05";
    stable.url = "github:nixos/nixpkgs/nixos-21.11";
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    latest.url = "github:nixos/nixpkgs";

    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.nixlib.follows = "nixos";
    digga.inputs.home-manager.follows = "home";
    digga.inputs.deploy.follows = "deploy";

    bud.url = "github:divnix/bud";
    bud.inputs.nixpkgs.follows = "nixos";
    bud.inputs.devshell.follows = "digga/devshell";

    beautysh.url = "github:lovesegfault/beautysh";
    bud.inputs.beautysh.follows = "beautysh";

    home.url = "github:nix-community/home-manager";
    home.inputs.nixpkgs.follows = "nixos";

    deploy.url = "github:input-output-hk/deploy-rs";
    deploy.inputs.nixpkgs.follows = "nixos";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixos";

    nvfetcher.url = "github:berberman/nvfetcher";
    nvfetcher.inputs.nixpkgs.follows = "nixos";

    naersk.url = "github:nmattia/naersk";
    naersk.inputs.nixpkgs.follows = "nixos";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    impermanence.url = "github:nix-community/impermanence";

    hlissner-dotfiles.url = "github:hlissner/dotfiles";

    # --- Application-Specific Flake Inputs
    # # --- PolyMC
    # polymc.url = "github:PolyMC/PolyMC";

    # # --- Powercord
    powercord = { url = "github:powercord-org/powercord"; flake = false; };
    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
    powercord-overlay.inputs.nixpkgs.follows = "latest";
    powercord-overlay.inputs.powercord.follows = "powercord";

    # # # --- Themes
    discord-amoled-cord = { url = "github:LuckFire/amoled-cord"; flake = false; };

    # # # --- Plugins
    discord-Custom-Volume-Range = { url = "github:PandaDriver156/Custom-Volume-Range"; flake = false; };
    discord-In-app-notifs = { url = "github:BenSegal855/In-app-notifs"; flake = false; };
    discord-NSFW-tags = { url = "github:E-boi/NSFW-tags"; flake = false; };
    discord-PowerAliases = { url = "github:LandenStephenss/PowerAliases"; flake = false; };
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
  };

  outputs =
    { self
    , digga
    , bud
    , nixos
    , home
    , nixos-hardware
    , nur
    , agenix
    , nvfetcher
    , deploy
    , ...
    }@inputs:
    digga.lib.mkFlake
      {
        inherit self inputs;

        patches = ./overlays/patches;

        channelsConfig = { allowUnfree = true; };

        channels = {
          nixos = {
            imports = [ (digga.lib.importOverlays ./overlays) ];
            overlays = [
              # --- DevOS Overlays
              nur.overlay
              agenix.overlay
              nvfetcher.overlay
              ./pkgs/default.nix

              # --- Application-Specific Overlays
              inputs.powercord-overlay.overlay
              # inputs.polymc.overlay
            ];
          };
          verystable = { };
          stable = { };
          latest = { };
        };

        lib = import ./lib { lib = digga.lib // nixos.lib; };

        sharedOverlays = [
          (final: prev: {
            __dontExport = true;
            lib = prev.lib.extend (lfinal: lprev: { our = self.lib; hlissner = inputs.hlissner-dotfiles.lib; });
          })
        ];

        nixos = {
          hostDefaults = {
            system = "x86_64-linux";
            channelName = "nixos";
            imports = [ (digga.lib.importExportableModules ./modules) ];
            modules = [
              { lib.our = self.lib; }
              digga.nixosModules.bootstrapIso
              digga.nixosModules.nixConfig
              home.nixosModules.home-manager
              agenix.nixosModules.age
              bud.nixosModules.bud

              inputs.impermanence.nixosModules.impermanence
            ];
          };

          imports = [ (digga.lib.importHosts ./hosts) ];
          hosts = {
            # Desktops
            Infini-DESKTOP = { };

            # Laptops
            Infini-SWIFT = { };
            Infini-FRAMEWORK = { };

            # Servers
            Infini-SERVER = { };
          };
          importables = rec {
            inherit (self) patches;

            profiles = digga.lib.rakeLeaves ./profiles // {
              users = digga.lib.rakeLeaves ./users;
            };
            suites = with profiles; self.lib.flattenSetList
              rec {
                base = [
                  core
                  (with users; [ root infinidoge ])
                ];
                graphic = base ++ [ graphical.qtile ];

                develop = [
                  (with profiles.develop.programming; [
                    python
                    racket
                    haskell
                    nim
                  ])
                ];
              };
          };
        };

        home = {
          imports = [ (digga.lib.importExportableModules ./users/modules) ];
          modules = [ "${inputs.impermanence}/home-manager.nix" ];
          importables = rec {
            inherit inputs;
            inherit (self) patches;

            profiles = digga.lib.rakeLeaves ./users/profiles;
            suites = with profiles; self.lib.flattenSetList
              rec {
                base = [
                  # Base Configuration
                  xdg

                  # Programs
                  direnv
                  git
                  emacs
                  vim
                  gpg
                  ssh
                  keychain

                  # Terminal
                  starship
                  shells.all
                  tmux
                ];

                graphic = [
                  kitty
                  rofi
                  themeing
                ];
              };
          };
          users = {
            infinidoge = { };
          }; # digga.lib.importers.rakeLeaves ./users/hm;
        };

        devshell = ./shell;

        homeConfigurations =
          digga.lib.mkHomeConfigurations self.nixosConfigurations;

        deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };

        defaultTemplate = self.templates.bud;
        templates.bud.path = ./.;
        templates.bud.description = "bud template";

      }
    //
    {
      budModules = { devos = import ./shell/bud; };
    }
  ;
}
