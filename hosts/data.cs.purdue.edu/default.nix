{ private, config, lib, pkgs, ... }:

{
  modules.hardware.form.server = true;

  system.stateVersion = "23.11";

  networking = {
    domain = "cs.purdue.edu";
    hostName = "data";
  };

  home-manager.useUserPackages = false;

  home = { main, config, ... }: {
    home = {
      username = lib.mkForce private.variables.purdue-username;

      packages = with pkgs; [
        home-manager
      ] ++ main.universe.packages;

      inherit (main.universe) shellAliases;

      sessionVariables = {
        TMPDIR = "${config.home.homeDirectory}/scratch/tmp";
        UNIVERSE_FLAKE_ROOT = "${config.home.homeDirectory}/universe";
        UNIVERSE_USERNAME = config.home.username;
      };

      file.".profile".target = ".profile-hm";

      homeDirectory = lib.mkForce "/homes/${config.home.username}";
    };
  };
}
