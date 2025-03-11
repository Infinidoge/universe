{
  lib,
  pkgs,
  private,
  ...
}:

{
  system.stateVersion = "23.11";

  modules.hardware.form.server = true;
  modules.secrets.enable = false;

  networking = {
    domain = "cs.purdue.edu";
    hostName = "data";
  };

  home-manager.useUserPackages = false;

  home =
    { main, config, ... }:
    {
      home = {
        username = lib.mkForce private.variables.purdue-username;

        packages =
          with pkgs;
          [
            home-manager
          ]
          ++ main.universe.packages;

        inherit (main.universe) shellAliases;

        sessionVariables = {
          TMPDIR = "${config.home.homeDirectory}/scratch/tmp";
          UNIVERSE_FLAKE_ROOT = "${config.home.homeDirectory}/universe";
          UNIVERSE_USERNAME = main.user.name;
          SHELL = "zsh";
        };

        file.".profile".target = ".profile-hm";

        homeDirectory = lib.mkForce "/homes/${config.home.username}";
      };

      nix.settings = {
        inherit (main.nix.settings)
          auto-optimise-store
          experimental-features
          fallback
          flake-registry
          keep-derivations
          keep-outputs
          min-free
          sandbox
          use-xdg-base-directories
          ;
      };
    };
}
