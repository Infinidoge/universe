{
  config,
  lib,
  pkgs,
  ...
}:
{
  home-manager = {
    useUserPackages = lib.mkDefault true;
    useGlobalPkgs = true;
    backupFileExtension = "old";

    sharedModules = [
      {
        options.info = lib.our.mkOpt lib.types.attrs { };
        config.info = config.info;

        options.common = lib.our.mkOpt lib.types.attrs { };
        config.common = config.common;
      }
      {
        home = {
          stateVersion = "24.05";
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
          userDirs = {
            enable = true;
            createDirectories = true;
          };
        };
        news.display = "silent";
        news.entries = lib.mkForce [ ];
      }
      (lib.mkIf config.info.graphical {
        xdg.systemDirs.data = [
          "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
          "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
        ];
      })
    ];
  };
}
