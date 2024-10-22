# Heavily inspired by hlissner: https://github.com/hlissner/dotfiles/blob/master/modules/options.nix
{ config, options, lib, ... }:
with lib;
with lib.our;
let
  mkAliasOpt = mkOpt types.attrs { };
  mkInfoOpt = mkOpt types.str "";
in
{
  options = with types; {
    user = mkAliasOpt;
    home = mkAliasOpt;

    dotfiles = {
      dir = mkOpt str "/etc/nixos";
      homeFile = mkAliasOpt;
      configFile = mkAliasOpt;
      dataFile = mkAliasOpt;
    };

    env = mkAliasOpt;

    persist = mkAliasOpt;
    storage = mkAliasOpt;

    info = {
      monitors = mkOpt int 1;
      graphical = mkBoolOpt config.services.xserver.enable;
      model = mkOpt str "A Computer";
      env = {
        wm = mkInfoOpt;
      };
      stationary = mkBoolOpt false;
      loc = {
        home = mkBoolOpt false;
        purdue = mkBoolOpt false;
      };
    };

    universe = {
      packages = mkOpt (listOf package) [ ];
      shellAliases = mkOpt (attrsOf str) { };
      variables = mkOpt (attrsOf (oneOf [ (listOf str) str path ])) { };
    };

    common = mkOpt (attrsOf anything) { };
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

    environment.persistence."/persist" = mkAliasDefinitions options.persist;
    environment.persistence."/storage" = lib.mkAliasDefinitions options.storage;
  };
}
