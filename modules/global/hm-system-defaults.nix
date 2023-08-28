{ config, lib, pkgs, ... }: {
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    extraSpecialArgs = {
      main = config;
    };

    sharedModules = [
      ({ profiles, ... }: {
        imports = with profiles; [
          # Base configuration
          xdg

          # Programs
          direnv
          emacs
          git
          gpg
          htop
          keychain
          ssh
          vim

          # Terminal
          shells.all
          starship
          tmux
        ];

        home = {
          stateVersion = config.system.stateVersion;
          sessionVariables = {
            inherit (config.environment.sessionVariables) NIX_PATH;
          };
        };
        xdg = {
          enable = true;
          configFile = {
            "nix/registry.json".text = config.environment.etc."nix/registry.json".text;
            "nixpkgs/config.nix".text = lib.generators.toPretty { } {
              allowUnfree = true;
            };
          };
        };
      })
      (lib.mkIf config.services.xserver.enable {
        xsession.enable = true;
      })
      (lib.mkIf config.info.graphical ({ profiles, ... }: {
        imports = with profiles; [
          kitty
        ];

        xdg.systemDirs.data = [
          "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
          "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
        ];
      }))
    ];
  };
}
