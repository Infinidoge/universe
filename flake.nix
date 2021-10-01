{
  description = "A highly structured configuration database.";

  nixConfig.extra-experimental-features = "nix-command flakes ca-references";
  nixConfig.extra-substituters =
    "https://nrdxp.cachix.org https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys =
    "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs = {
    # --- DevOS Flake Inputs
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    latest.url = "github:nixos/nixpkgs";

    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.nixlib.follows = "nixos";
    digga.inputs.home-manager.follows = "home";

    bud.url = "github:divnix/bud";
    bud.inputs.nixpkgs.follows = "nixos";
    bud.inputs.devshell.follows = "digga/devshell";

    home.url = "github:nix-community/home-manager";
    home.inputs.nixpkgs.follows = "nixos";

    deploy.follows = "digga/deploy";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "latest";

    nvfetcher.url = "github:berberman/nvfetcher";
    nvfetcher.inputs.nixpkgs.follows = "latest";
    nvfetcher.inputs.flake-compat.follows = "digga/deploy/flake-compat";
    nvfetcher.inputs.flake-utils.follows = "digga/flake-utils-plus/flake-utils";

    naersk.url = "github:nmattia/naersk";
    naersk.inputs.nixpkgs.follows = "latest";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # start ANTI CORRUPTION LAYER
    # remove after https://github.com/NixOS/nix/pull/4641
    nixpkgs.follows = "nixos";
    nixlib.follows = "digga/nixlib";
    blank.follows = "digga/blank";
    flake-utils-plus.follows = "digga/flake-utils-plus";
    flake-utils.follows = "digga/flake-utils";
    # end ANTI CORRUPTION LAYER

    # --- Application-Specific Flake Inputs
    # # --- Powercord
    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
    powercord-overlay.inputs.nixpkgs.follows = "latest";
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

        channelsConfig = { allowUnfree = true; };

        channels = {
          nixos = {
            imports = [ (digga.lib.importOverlays ./overlays) ];
            overlays = [
              # --- DevOS Overlays
              digga.overlays.patchedNix
              nur.overlay
              agenix.overlay
              nvfetcher.overlay
              deploy.overlay
              ./pkgs/default.nix

              # --- Application-Specific Overlays
              inputs.powercord-overlay.overlay
            ];
          };
          latest = { };
        };

        lib = import ./lib { lib = digga.lib // nixos.lib; };

        sharedOverlays = [
          (final: prev: {
            __dontExport = true;
            lib = prev.lib.extend (lfinal: lprev: { our = self.lib; });
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
            ];
          };

          imports = [ (digga.lib.importHosts ./hosts) ];
          hosts = {
            # set host specific properties here
            Infini-DESKTOP = { };
            Infini-SWIFT = { };
          };
          importables = rec {
            profiles = digga.lib.rakeLeaves ./profiles // {
              users = digga.lib.rakeLeaves ./users;
            };
            suites = with profiles; rec {
              base = [ core users.root users.infinidoge ];
              graphic = base ++ [ graphical.qtile ];

              develop = nixos.lib.lists.flatten [
                (with profiles.develop.programming; [ python racket ])
              ];
            };
            test = self.lib;
          };
        };

        home = {
          imports = [ (digga.lib.importExportableModules ./users/modules) ];
          modules = [ ];
          importables = rec {
            profiles = digga.lib.rakeLeaves ./users/profiles;
            suites = with profiles; rec {
              base = [
                # Base Configuration
                xdg

                # Programs
                direnv
                git
                pass
                emacs
                gaming

                # Terminal
                kitty
                starship
                shells.all
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

      } // {
      budModules = { devos = import ./bud; };
    };
}
