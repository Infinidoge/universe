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
    private.url = "git+ssh://git@inx.moe/Infinidoge/universe-private";
    universe-cli.url = "git+ssh://git@inx.moe/Infinidoge/universe-cli";
    swedish-fish.url = "git+ssh://git@inx.moe/swedish.fish/infrastructure";

    ### Nix Libraries
    agenix.url = "github:ryantm/agenix";
    agenix-rekey.url = "github:oddlama/agenix-rekey";
    devshell.url = "github:numtide/devshell";
    disko.url = "github:nix-community/disko/latest";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager";
    impermanence.url = "github:nix-community/impermanence";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nixos-hardware.url = "github:nixos/nixos-hardware";
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
    xonsh.url = "github:xonsh/xonsh";

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
    impermanence.inputs.home-manager.follows = "home-manager";
    impermanence.inputs.nixpkgs.follows = "nixpkgs";
    lix-module.inputs.flake-utils.follows = "flake-utils";
    lix-module.inputs.lix.follows = "lix";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    lix.inputs.flake-compat.follows = "blank";
    lix.inputs.nixpkgs.follows = "nixpkgs"; # TODO: pin to blank
    lix.inputs.pre-commit-hooks.follows = "git-hooks"; # TODO: pin to blank
    nil.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-minecraft.inputs.flake-compat.follows = "blank";
    nix-minecraft.inputs.systems.follows = "systems";
    nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.flake-parts.follows = "flake-parts";
    nixvim.inputs.systems.follows = "systems";
    qtile.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    universe-cli.inputs.devshell.follows = "devshell";
    universe-cli.inputs.flake-parts.follows = "flake-parts";
    universe-cli.inputs.nixpkgs.follows = "nixpkgs";
    universe-cli.inputs.rust-overlay.follows = "rust-overlay";
    xonsh.inputs.nixpkgs.follows = "nixpkgs";
    xonsh.inputs.systems.follows = "systems";
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
          libOverlay = (
            lfinal: lprev: {
              our = self.lib;
              hm = inputs.home-manager.lib.hm;
            }
          );

          users = self.lib.rakeLeaves ./users;
          nixos = self.lib.rakeLeaves ./nixos;
          home = self.lib.rakeLeaves ./home;
          vendored = self.lib.rakeLeaves ./vendored;

          overlays = {
            overrides = import ./overlays/overrides.nix inputs;
            patches = import ./overlays/patches;
            inputs = (
              final: prev: {
                inherit (inputs.home-manager.packages.${prev.stdenv.hostPlatform.system}) home-manager;
                inherit (inputs.qtile.packages.${prev.stdenv.hostPlatform.system}) qtile;
              }
            );
            lib = (
              final: prev: {
                lib = prev.lib.extend self.libOverlay;
              }
            );
          };

          nixosConfigurations = lib.mapAttrs (self.lib.mkHost {
            specialArgs = {
              lib = nixpkgs.lib.extend self.libOverlay;
              inherit private self inputs;
              inherit (self) nixos home;
            };

            modules = [
              self.users.root
              self.users.infinidoge
              {
                nixpkgs.hostPlatform = "x86_64-linux";
                system.configurationRevision = lib.mkIf (self ? rev) self.rev;
                nixpkgs.overlays = [
                  self.overlays.packages
                  self.overlays.patches
                  self.overlays.overrides
                  self.overlays.inputs
                  self.overlays.lib

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
                  extraSpecialArgs = {
                    inherit private self inputs;
                    inherit (self) home;
                  };
                };
              }

              # --- Library Modules ---
              inputs.disko.nixosModules.disko
              inputs.impermanence.nixosModules.impermanence

              # --- Domain-Specific Modules ---
              inputs.nix-minecraft.nixosModules.minecraft-servers
              inputs.copyparty.nixosModules.default
            ];
          }) (self.lib.flattenLeaves ./hosts);

          homeConfigurations.infinidoge = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = {
              lib = nixpkgs.lib.extend self.libOverlay;
              inherit private self inputs;
              inherit (self) nixos home;
            };
            modules = with self.home; [
              {
                # HACK: Should be set per host
                home.stateVersion = "26.05";
                home.username = "infinidoge";
                home.homeDirectory = "/home/infinidoge";
                info.model = "Some Computer";
                info.env.wm = "";

                nixpkgs.config.allowUnfree = true;

                nixpkgs.overlays = [
                  self.overlays.packages
                  self.overlays.patches
                  self.overlays.overrides
                  self.overlays.inputs
                  self.overlays.lib

                  # --- Domain-Specific Overlays
                  inputs.agenix.overlays.default
                  inputs.rust-overlay.overlays.default
                  inputs.universe-cli.overlays.default
                  inputs.nil.overlays.default
                ];
              }
              {
                # HACK: Should be defined elsewhere
                options.info = self.lib.mkOpt lib.types.attrs { };
                options.common = self.lib.mkOpt lib.types.attrs { };
              }

              # --- Universe Modules ---
              base
              direnv
              dotfiles.neofetch
              git
              gpg
              htop
              neovim
              nix-index
              programming.base
              programming.nix
              programming.python
              shells.bash
              shells.xonsh
              shells.zsh
              ssh
              starship
              tealdeer
              vim
              zoxide

              ./users/infinidoge/home.nix
            ];
          };

          hydraJobs = {
            packages = lib.mapAttrs (
              _: lib.filterAttrs (n: v: v ? meta -> v.meta ? broken -> !v.meta.broken)
            ) self.packages;
            nixosConfigurations.x86_64-linux =
              lib.flip lib.genAttrs
                (name: { toplevel = self.nixosConfigurations.${name}.config.system.build.toplevel; })
                [
                  "apophis"
                  "artemis"
                  "bacchus"
                  "daedalus"
                  "dionysus"
                  #"hermes"
                  #"hestia"
                  "iris"
                  "lethe"
                  "pluto"
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
