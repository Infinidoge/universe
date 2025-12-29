{
  description = "Infinidoge's NixOS configuration";

  nixConfig = {
    allow-import-from-derivation = true;
    extra-experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operator"
    ];
  };

  inputs = {
    ### Nixpkgs ###
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    latest.url = "github:NixOS/nixpkgs";
    fork.url = "github:Infinidoge/nixpkgs/combined/all";
    stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    old-stable.url = "github:NixOS/nixpkgs/nixos-23.05"; # HACK: For schildichat

    ### Configuration Components ###
    private.url = "git+ssh://git@github.com/Infinidoge/universe-private";
    universe-cli.url = "github:Infinidoge/universe-cli";

    ### Nix Libraries
    agenix.url = "github:ryantm/agenix";
    agenix-rekey.url = "github:oddlama/agenix-rekey";
    devshell.url = "github:numtide/devshell";
    disko.url = "github:nix-community/disko/latest";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-registry = {
      url = "github:NixOS/flake-registry";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager";
    impermanence.url = "github:nix-community/impermanence";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    ### Domain-Specific Flake Inputs ###
    ## Lix
    lix.url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
    hydra.url = "https://git.lix.systems/lix-project/hydra/archive/main.tar.gz";
    nil.url = "github:oxalica/nil";

    ## Minecraft
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    drasl.url = "github:unmojang/drasl";

    ## Rust
    rust-overlay.url = "github:oxalica/rust-overlay";

    ## Neovim
    nixvim.url = "github:nix-community/nixvim";

    ## Vencord
    vencord = {
      url = "github:Vendicated/Vencord";
      flake = false;
    };

    ## Qtile
    qtile.url = "github:qtile/qtile";

    ## Authentik
    authentik-nix.url = "github:nix-community/authentik-nix";

    # Misc
    copyparty.url = "github:9001/copyparty";

    ### Cleanup ###
    ## Common
    blank.url = "github:divnix/blank";
    flake-utils.url = "github:numtide/flake-utils";
    git-hooks.url = "github:cachix/git-hooks.nix";
    systems.url = "github:nix-systems/default";

    ## Follow common
    agenix-rekey.inputs.devshell.follows = "devshell";
    agenix-rekey.inputs.flake-parts.follows = "flake-parts";
    agenix-rekey.inputs.nixpkgs.follows = "nixpkgs";
    agenix-rekey.inputs.pre-commit-hooks.follows = "git-hooks";
    agenix-rekey.inputs.treefmt-nix.follows = "treefmt-nix";
    agenix.inputs.darwin.follows = "blank";
    agenix.inputs.home-manager.follows = "home-manager";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.systems.follows = "systems";
    authentik-nix.inputs.flake-compat.follows = "blank";
    authentik-nix.inputs.flake-parts.follows = "flake-parts";
    authentik-nix.inputs.flake-utils.follows = "flake-utils";
    authentik-nix.inputs.nixpkgs.follows = "nixpkgs";
    authentik-nix.inputs.poetry2nix.inputs.treefmt-nix.follows = "treefmt-nix";
    authentik-nix.inputs.systems.follows = "systems";
    copyparty.inputs.flake-utils.follows = "flake-utils";
    copyparty.inputs.nixpkgs.follows = "nixpkgs";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    drasl.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    flake-utils.inputs.systems.follows = "systems";
    git-hooks.inputs.flake-compat.follows = "blank";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hydra.inputs.lix.follows = "lix";
    hydra.inputs.nixpkgs.follows = "nixpkgs";
    lix-module.inputs.flake-utils.follows = "flake-utils";
    lix-module.inputs.lix.follows = "lix";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    lix.inputs.flake-compat.follows = "blank";
    lix.inputs.nixpkgs.follows = "nixpkgs"; # TODO: pin to blank
    lix.inputs.pre-commit-hooks.follows = "git-hooks"; # TODO: pin to blank
    nil.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-minecraft.inputs.flake-compat.follows = "blank";
    nix-minecraft.inputs.flake-utils.follows = "flake-utils";
    nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.flake-compat.follows = "blank";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.flake-parts.follows = "flake-parts";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nuschtosSearch.follows = "blank";
    qtile.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    universe-cli.inputs.devshell.follows = "devshell";
    universe-cli.inputs.flake-parts.follows = "flake-parts";
    universe-cli.inputs.flake-utils.follows = "flake-utils";
    universe-cli.inputs.nixpkgs.follows = "nixpkgs";
    universe-cli.inputs.rust-overlay.follows = "rust-overlay";
    universe-cli.inputs.systems.follows = "systems";
  };

  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      private,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { self, lib, ... }:
      {
        systems = [ "x86_64-linux" ];

        debug = true;

        perSystem =
          { pkgs, system, ... }:
          {
            _module.args.pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
              overlays = [
                self.overlays.overrides
                self.overlays.patches
              ];
            };

            treefmt.projectRootFile = "flake.nix";
            treefmt.programs.nixfmt.enable = true;

            # Home Manager configurations are extracted from NixOS hosts, ignore
            agenix-rekey.homeConfigurations = { };
          };

        flake = {
          lib = import ./lib { inherit (nixpkgs) lib; };

          users = self.lib.rakeLeaves ./users;

          overlays = {
            overrides = import ./overlays/overrides.nix inputs;
            patches = import ./overlays/patches;
          };

          nixosConfigurations =
            let
              libOverlay = (
                lfinal: lprev: {
                  our = self.lib;
                  hm = inputs.home-manager.lib.hm;
                }
              );
            in
            lib.mapAttrs (self.lib.mkHost {
              specialArgs = {
                lib = nixpkgs.lib.extend libOverlay;
                inherit private self inputs;
              };

              modules = [
                self.users.root
                self.users.infinidoge
                {
                  nixpkgs.hostPlatform = "x86_64-linux";
                  system.configurationRevision = lib.mkIf (self ? rev) self.rev;
                  nixpkgs.overlays = [
                    (final: prev: {
                      lib = prev.lib.extend libOverlay;

                      inherit (inputs.home-manager.packages.${prev.system}) home-manager;
                      inherit (inputs.qtile.packages.${prev.system}) qtile;
                    })
                    self.overlays.packages
                    self.overlays.patches
                    self.overlays.overrides

                    # --- Domain-Specific Overlays
                    inputs.agenix.overlays.default
                    inputs.copyparty.overlays.default
                    inputs.hydra.overlays.default
                    inputs.nil.overlays.default
                    inputs.nix-minecraft.overlay
                    inputs.rust-overlay.overlays.default
                    inputs.universe-cli.overlays.default
                  ];
                  home-manager = {
                    sharedModules = [
                      inputs.impermanence.nixosModules.home-manager.impermanence
                      inputs.nix-index-database.homeModules.nix-index
                      inputs.nixvim.homeModules.nixvim
                    ]
                    ++ (self.lib.leaves ./users/modules);
                  };
                }
                (
                  { config, pkgs, ... }:
                  {
                    age.rekey = {
                      storageMode = "local";
                      generatedSecretsDir = ./secrets/generated;
                      localStorageDir = ./. + "/secrets/rekeyed/${config.networking.hostName}";
                      agePlugins = with pkgs; [
                        age-plugin-fido2-hmac
                        age-plugin-yubikey
                      ];
                    };
                  }
                )

                # --- Universe Modules ---
                ./secrets
                private.nixosModules.secrets

                # --- Library Modules ---
                inputs.agenix.nixosModules.default
                inputs.agenix-rekey.nixosModules.default
                inputs.disko.nixosModules.disko
                inputs.home-manager.nixosModules.home-manager
                inputs.impermanence.nixosModules.impermanence
                inputs.nix-index-database.nixosModules.nix-index
                inputs.nixos-wsl.nixosModules.wsl

                # --- Domain-Specific Modules ---
                inputs.authentik-nix.nixosModules.default
                inputs.lix-module.nixosModules.default
                inputs.hydra.nixosModules.hydra
                inputs.nix-minecraft.nixosModules.minecraft-servers
                inputs.drasl.nixosModules.drasl
                inputs.copyparty.nixosModules.default
              ]
              ++ (self.lib.leaves ./modules);
            }) (self.lib.flattenLeaves ./hosts);

          homeConfigurations = self.lib.mkHomeConfigurations {
            inherit (self.nixosConfigurations)
              "data.cs.purdue.edu"
              vulcan
              ;
          };

          hydraJobs = {
            packages = lib.mapAttrs (
              _: lib.filterAttrs (n: v: v ? meta -> v.meta ? broken -> !v.meta.broken)
            ) self.packages;
            nixosConfigurations.x86_64-linux =
              lib.flip lib.genAttrs
                (name: { toplevel = self.nixosConfigurations.${name}.config.system.build.toplevel; })
                [
                  "Infini-DESKTOP"
                  "Infini-DL360"
                  "artemis"
                  "Infini-OPTIPLEX"
                  "Infini-SERVER"
                  "hermes"
                  "hestia"
                ];
          };
        };

        imports = [
          ./pkgs
          ./shell.nix
          ./templates
          inputs.agenix-rekey.flakeModule
          inputs.devshell.flakeModule
          inputs.treefmt-nix.flakeModule
        ];
      }
    );
}
