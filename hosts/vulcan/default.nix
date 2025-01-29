{ pkgs, ... }:

{
  modules.hardware.form.server = true;
  modules.secrets.enable = false;
  info.loc.home = false;
  info.loc.purdue = true;

  system.stateVersion = "24.11";

  home-manager.useUserPackages = false;

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

      universe.programming.all.enable = true;
    };
}
