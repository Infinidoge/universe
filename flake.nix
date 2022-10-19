{
  description = "Infinidoge's NixOS configuration";

  inputs = {
    # --- DevOS Flake Inputs
    # # --- Channels ---
    stable.url = "github:nixos/nixpkgs/nixos-22.05";
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    latest.url = "github:nixos/nixpkgs";
    staging.url = "github:nixos/nixpkgs/staging";
    fork.url = "github:Infinidoge/nixpkgs/combined/all";

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

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    # --- Domain-Specific Flake Inputs
    # # --- Minecraft
    nix-minecraft.url = "github:Infinidoge/nix-minecraft/develop";
    nix-minecraft.inputs.nixpkgs.follows = "nixos";
    prismlauncher.url = "github:PrismLauncher/PrismLauncher";
    prismlauncher.inputs.nixpkgs.follows = "nixos";

    # # --- Rust
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixos";
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

              # --- Domain-Specific Overlays
              inputs.nix-minecraft.overlay
              inputs.prismlauncher.overlay
              inputs.fenix.overlay
            ];
          };
          stable = { };
          latest = { };
          staging = { };
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
              # --- DevOS Modules ---
              { lib.our = self.lib; }
              digga.nixosModules.bootstrapIso
              digga.nixosModules.nixConfig
              home.nixosModules.home-manager
              agenix.nixosModules.age
              bud.nixosModules.bud
              ./secrets

              # --- Library Modules ---
              inputs.nixos-wsl.nixosModules.wsl
              inputs.impermanence.nixosModules.impermanence
              inputs.quick-nix-registry.nixosModules.local-registry

              # --- Domain-Specific Modules ---
              inputs.nix-minecraft.nixosModules.minecraft-servers
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
                  (with users; [ root infinidoge ])
                ];

                develop = [
                  (with profiles.develop.programming; [
                    python
                    racket
                    haskell
                    java
                    nim
                    rust
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
                  flameshot
                ];
              };
          };
        };

        devshells.x86_64-linux.default = ./shell;

        homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

        deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };

        templates.default = self.templates.bud;
        templates.bud.path = ./.;
        templates.bud.description = "bud template";

      }
    //
    {
      budModules = { devos = import ./shell/bud; };
    }
  ;
}
