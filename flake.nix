{
  description = "Infinidoge's NixOS configuration";

  nixConfig = {
    allow-import-from-derivation = true;
  };

  inputs = {
    ### Nixpkgs ###
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    latest.url = "github:NixOS/nixpkgs";
    fork.url = "github:Infinidoge/nixpkgs/combined/all";
    stable.url = "github:NixOS/nixpkgs/nixos-23.05";

    ### Configuration Components ###
    private.url = "git+ssh://git@github.com/Infinidoge/universe-private";
    universe-cli.url = "github:Infinidoge/universe-cli";

    ### Nix Libraries
    agenix.url = "github:ryantm/agenix";
    devshell.url = "github:numtide/devshell";
    disko.url = "github:nix-community/disko";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-registry = { url = "github:NixOS/flake-registry"; flake = false; };
    home-manager.url = "github:nix-community/home-manager";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    ### Domain-Specific Flake Inputs ###
    ## Lix
    lix.url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
    lix.inputs.nixpkgs.follows = "nixpkgs";
    lix.inputs.pre-commit-hooks.follows = "git-hooks";
    lix.inputs.flake-compat.follows = "blank";
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    lix-module.inputs.lix.follows = "lix";
    hydra.url = "https://git.lix.systems/lix-project/hydra/archive/main.tar.gz";
    hydra.inputs.nixpkgs.follows = "nixpkgs";

    ## Minecraft
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    ## Rust
    rust-overlay.url = "github:oxalica/rust-overlay";

    ## Neovim
    nixvim.url = "github:nix-community/nixvim";

    ## Conduwuit
    conduwuit.url = "github:girlbossceo/conduwuit";

    ### Cleanup ###
    ## Common
    blank.url = "github:divnix/blank";
    flake-utils.url = "github:numtide/flake-utils";
    git-hooks.url = "github:cachix/git-hooks.nix";
    systems.url = "github:nix-systems/default";

    ## Follow common
    agenix.inputs.darwin.follows = "blank";
    agenix.inputs.home-manager.follows = "home-manager";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.systems.follows = "systems";
    conduwuit.inputs.attic.follows = "blank";
    conduwuit.inputs.cachix.follows = "blank";
    conduwuit.inputs.flake-compat.follows = "blank";
    conduwuit.inputs.flake-utils.follows = "flake-utils";
    conduwuit.inputs.nixpkgs.follows = "nixpkgs";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    flake-utils.inputs.systems.follows = "systems";
    git-hooks.inputs.flake-compat.follows = "blank";
    git-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    lix-module.inputs.flake-utils.follows = "flake-utils";
    nix-minecraft.inputs.flake-compat.follows = "blank";
    nix-minecraft.inputs.flake-utils.follows = "flake-utils";
    nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.flake-compat.follows = "blank";
    nixos-wsl.inputs.flake-utils.follows = "flake-utils";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.devshell.follows = "devshell";
    nixvim.inputs.flake-compat.follows = "blank";
    nixvim.inputs.flake-parts.follows = "flake-parts";
    nixvim.inputs.git-hooks.follows = "git-hooks";
    nixvim.inputs.home-manager.follows = "home-manager";
    nixvim.inputs.nix-darwin.follows = "blank";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.treefmt-nix.follows = "treefmt-nix";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    universe-cli.inputs.devshell.follows = "devshell";
    universe-cli.inputs.flake-parts.follows = "flake-parts";
    universe-cli.inputs.flake-utils.follows = "flake-utils";
    universe-cli.inputs.nixpkgs.follows = "nixpkgs";
    universe-cli.inputs.rust-overlay.follows = "rust-overlay";
    universe-cli.inputs.systems.follows = "systems";
  };

  outputs = inputs@{ flake-parts, nixpkgs, private, ... }: flake-parts.lib.mkFlake { inherit inputs; } ({ self, lib, ... }: {
    systems = [ "x86_64-linux" ];

    debug = true;

    perSystem = { pkgs, system, ... }: {
      _module.args.pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          self.overlays.overrides
          self.overlays.patches
        ];
      };

      treefmt.projectRootFile = "flake.nix";
      treefmt.programs.nixpkgs-fmt.enable = true;
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
          libOverlay = (lfinal: lprev: {
            our = self.lib;
            hm = inputs.home-manager.lib.hm;
          });
        in
        lib.mapAttrs
          (self.lib.mkHost {
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
                  })
                  self.overlays.packages
                  self.overlays.patches
                  self.overlays.overrides

                  # --- Domain-Specific Overlays
                  inputs.agenix.overlays.default
                  inputs.nix-minecraft.overlay
                  inputs.rust-overlay.overlays.default
                  inputs.universe-cli.overlays.default
                ];
                home-manager = {
                  sharedModules = [
                    inputs.impermanence.nixosModules.home-manager.impermanence
                    inputs.nixvim.homeManagerModules.nixvim
                  ] ++ (self.lib.leaves ./users/modules);
                };
              }

              # --- Universe Modules ---
              ./secrets
              private.nixosModules.secrets

              # --- Library Modules ---
              inputs.agenix.nixosModules.age
              inputs.disko.nixosModules.disko
              inputs.home-manager.nixosModules.home-manager
              inputs.impermanence.nixosModules.impermanence
              inputs.nixos-wsl.nixosModules.wsl

              # --- Domain-Specific Modules ---
              inputs.lix-module.nixosModules.default
              inputs.hydra.nixosModules.overlayNixpkgsForThisHydra
              inputs.nix-minecraft.nixosModules.minecraft-servers
            ] ++ (self.lib.leaves ./modules);
          })
          (self.lib.flattenLeaves ./hosts);

      homeConfigurations = self.lib.mkHomeConfigurations { inherit (self.nixosConfigurations) "data.cs.purdue.edu"; };

      hydraJobs = {
        packages = lib.mapAttrs (_: lib.filterAttrs (n: v: v ? meta -> v.meta ? broken -> !v.meta.broken)) self.packages;
        nixosConfigurations.x86_64-linux = lib.flip lib.genAttrs (name: { toplevel = self.nixosConfigurations.${name}.config.system.build.toplevel; }) [
          "Infini-DESKTOP"
          "Infini-DL360"
          "Infini-FRAMEWORK"
          "Infini-OPTIPLEX"
          "Infini-SERVER"
        ];
      };
    };

    imports = [
      ./pkgs
      ./shell
      ./templates
      inputs.devshell.flakeModule
      inputs.treefmt-nix.flakeModule
    ];
  });
}
