{ config, lib, ... }: {
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    extraSpecialArgs = {
      main = config;
    };

    sharedModules = [
      {
        home.sessionVariables = {
          inherit (config.environment.sessionVariables) NIX_PATH;
        };
        xdg = {
          configFile."nix/registry.json".text = config.environment.etc."nix/registry.json".text;
          enable = true;
        };
        home.stateVersion = config.system.stateVersion;
      }
      (lib.mkIf config.services.xserver.enable {
        xsession.enable = true;
      })
    ];
  };
}
