{ private, config, lib, pkgs, ... }:

{
  modules.hardware.form.server = true;
  modules.secrets.enable = false;
  info.loc.home = false;

  system.stateVersion = "24.05";

  home-manager.useUserPackages = false;

  home = { main, config, ... }: {
    home = {
      packages = with pkgs; [
        home-manager
      ] ++ main.universe.packages;

      inherit (main.universe) shellAliases;

      sessionVariables = {
        UNIVERSE_FLAKE_ROOT = "${config.home.homeDirectory}/universe";
      };
    };
    nix.settings.use-xdg-base-directories = true;
  };
}
