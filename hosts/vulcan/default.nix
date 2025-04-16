{ pkgs, ... }:

{
  system.stateVersion = "24.11";

  modules.hardware.form.server = true;
  modules.secrets.enable = false;
  modules.backups.enable = false;
  info.loc.home = false;
  info.loc.purdue = true;

  home-manager.useUserPackages = false;

  universe.programming.all.enable = true;

  home =
    { main, config, ... }:
    {
      home = {
        packages =
          with pkgs;
          [
            home-manager
          ]
          ++ main.universe.packages;

        inherit (main.universe) shellAliases;

        sessionVariables = {
          UNIVERSE_FLAKE_ROOT = "${config.home.homeDirectory}/universe";
          UNIVERSE_MODE = "home-manager";
        };
      };
      nix.settings.use-xdg-base-directories = true;
    };
}
