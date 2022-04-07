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

    # home.url = "github:nix-community/home-manager";
    # FIXME: https://github.com/nix-community/home-manager/issues/2846
    home.urk = "github:wentasah/home-manager";
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
              inputs.powercord-setup.overlay
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
