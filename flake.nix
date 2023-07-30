{
  description = "Infinidoge's NixOS configuration";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    latest.url = "github:nixos/nixpkgs";
    fork.url = "github:Infinidoge/nixpkgs/combined/all";

    # configuration components
    private.url = "git+ssh://git@github.com/Infinidoge/universe-private";

    universe-cli.url = "github:Infinidoge/universe-cli";
    universe-cli.inputs.nixpkgs.follows = "nixpkgs";

    # nix libraries
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    haumea.url = "github:nix-community/haumea/v0.2.2";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "home-manager";

    devshell.url = "github:numtide/devshell";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    impermanence.url = "github:nix-community/impermanence";

    hlissner-dotfiles.url = "github:hlissner/dotfiles";

    quick-nix-registry.url = "github:divnix/quick-nix-registry";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    # --- Domain-Specific Flake Inputs
    # # --- Minecraft
    nix-minecraft.url = "github:Infinidoge/nix-minecraft/develop";
    nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";

    # # --- Rust
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ flake-parts, nixpkgs, private, ... }: flake-parts.lib.mkFlake { inherit inputs; } ({ self, lib, ... }: {
    systems = [ "x86_64-linux" ];

    debug = true;

    perSystem = { pkgs, system, ... }: {
      _module.args.pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };

    flake = {
      lib = import ./lib { inherit (nixpkgs) lib; };

      users = self.lib.rakeLeaves ./users;

      nixosProfiles = self.lib.rakeLeaves ./profiles;

      overlays = {
        overrides = import ./overlays/overrides.nix inputs;
        patches = import ./overlays/patches;
      };

      nixosConfigurations =
        let
          libOverlay = (lfinal: lprev: {
            our = self.lib;
            hlissner = inputs.hlissner-dotfiles.lib;
            hm = inputs.home-manager.lib.hm;
          });
        in
        lib.mapAttrs
          (self.lib.mkHost {
            specialArgs = {
              profiles = self.nixosProfiles;
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
                  })
                  self.overlays.packages
                  self.overlays.patches
                  self.overlays.overrides

                  inputs.agenix.overlays.default

                  # --- Domain-Specific Overlays
                  inputs.nix-minecraft.overlay
                  inputs.fenix.overlays.default
                  inputs.universe-cli.overlays.default
                ];
                home-manager =
                  let
                    profiles = self.lib.rakeLeaves ./users/profiles;
                  in
                  {
                    useUserPackages = true;
                    useGlobalPkgs = true;

                    sharedModules = [
                      inputs.impermanence.nixosModules.home-manager.impermanence
                    ] ++ (with profiles; [
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

                    ]) ++ (self.lib.leaves ./users/modules);

                    extraSpecialArgs = {
                      inherit profiles;
                    };
                  };
              }

              # --- Universe Modules ---
              ./secrets

              # --- Library Modules ---
              inputs.nixos-wsl.nixosModules.wsl
              inputs.impermanence.nixosModules.impermanence
              inputs.quick-nix-registry.nixosModules.local-registry
              inputs.home-manager.nixosModules.home-manager
              inputs.agenix.nixosModules.age

              # --- Domain-Specific Modules ---
              inputs.nix-minecraft.nixosModules.minecraft-servers
            ] ++ (self.lib.leaves ./modules);
          })
          (self.lib.flattenLeaves ./hosts);
    };

    imports = [
      ./pkgs
      ./shell
      inputs.devshell.flakeModule
    ];
  });
}
