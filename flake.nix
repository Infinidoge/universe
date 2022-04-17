{
  description = "A highly structured configuration database.";

  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substituters = "https://nrdxp.cachix.org https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys = "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs = {
    # --- DevOS Flake Inputs
    # # --- Channels ---
    verystable.url = "github:nixos/nixpkgs/nixos-21.05";
    stable.url = "github:nixos/nixpkgs/nixos-21.11";
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    latest.url = "github:nixos/nixpkgs";
    fork.url = "github:Infinidoge/nixpkgs";

    # # --- Libraries ---
    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.nixlib.follows = "nixos";
    digga.inputs.home-manager.follows = "home";
    digga.inputs.deploy.follows = "deploy";

    bud.url = "github:divnix/bud";
    bud.inputs.nixpkgs.follows = "nixos";
    bud.inputs.devshell.follows = "digga/devshell";

    home.url = "github:nix-community/home-manager";
    home.inputs.nixpkgs.follows = "nixos";

    deploy.url = "github:input-output-hk/deploy-rs";
    deploy.inputs.nixpkgs.follows = "nixos";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixos";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    impermanence.url = "github:nix-community/impermanence";

    hlissner-dotfiles.url = "github:hlissner/dotfiles";

    quick-nix-registry.url = "github:divnix/quick-nix-registry";

    # --- Application-Specific Flake Inputs
    # # --- Powercord
    powercord-setup.url = "path:/etc/nixos/subflakes/powercord";
    powercord-setup.inputs.nixpkgs.follows = "latest";
  };

  outputs =
    { self
    , digga
    , bud
    , nixos
    , home
    , agenix
    , deploy
    , ...
    }@inputs:
    digga.lib.mkFlake
      {
        inherit self inputs;

        channelsConfig = { allowUnfree = true; };

        channels = {
          nixos = {
            imports = [ (digga.lib.importOverlays ./overlays) ];
            overlays = [
              # --- DevOS Overlays
              agenix.overlay
              ./pkgs/default.nix

              # --- Application-Specific Overlays
              inputs.powercord-setup.overlay
            ];
          };
          verystable = { };
          stable = { };
          latest = { };
          fork = { };
        };

        lib = import ./lib { lib = digga.lib // nixos.lib; };

        sharedOverlays = [
          (final: prev: {
            __dontExport = true;
            lib = prev.lib.extend (lfinal: lprev: {
              our = self.lib;
              hlissner = inputs.hlissner-dotfiles.lib;
              hm = home.lib.hm;
            });
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
              inputs.quick-nix-registry.nixosModules.local-registry
            ];
          };

          imports = [ (digga.lib.importHosts ./hosts) ];
          importables = rec {
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
          modules = [
            inputs.impermanence.nixosModules.home-manager.impermanence
          ];
          importables = rec {
            inherit inputs;

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
        };

        devshell = ./shell;

        homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

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
