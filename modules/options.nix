# Heavily inspired by hlissner: https://github.com/hlissner/dotfiles/blob/master/modules/options.nix
{ config, options, lib, home-manager, ... }:
with lib;
with lib.hlissner;
{
  options = with types; {
    user = mkOpt attrs { };
    home = mkOpt attrs { };

    dotfiles = {
      dir = mkOpt str "/etc/nixos";
      homeFile = mkOpt attrs { };
      configFile = mkOpt attrs { };
      dataFile = mkOpt attrs { };
    };

    env = mkOpt attrs { };

    info = {
      monitors = mkOpt int 1;
      graphical = mkBoolOpt config.services.xserver.enable;
    };
  };

  config = {
    users.users.${config.user.name} = mkAliasDefinitions options.user;
    home-manager.users.${config.user.name} = mkAliasDefinitions options.home;

    home = {
      home.file = mkAliasDefinitions options.dotfiles.homeFile;
      xdg = {
        configFile = mkAliasDefinitions options.dotfiles.configFile;
        dataFile = mkAliasDefinitions options.dotfiles.dataFile;
      };
    };

    environment.variables = mkAliasDefinitions options.env;

    bud.localFlakeClone = config.dotfiles.dir;
  };
}
