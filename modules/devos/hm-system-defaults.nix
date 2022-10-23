{ config, lib, ... }: {
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    extraSpecialArgs = {
      main = config;
    };

    sharedModules = [
      {
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
      }
      (lib.mkIf config.services.xserver.enable {
        xsession.enable = true;
      })
    ];
  };
}
