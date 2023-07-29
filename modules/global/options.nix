# Heavily inspired by hlissner: https://github.com/hlissner/dotfiles/blob/master/modules/options.nix
{ config, options, lib, home-manager, ... }:
with lib;
with lib.hlissner;
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

    info = {
      monitors = mkOpt int 1;
      graphical = mkBoolOpt config.services.xserver.enable;
      model = mkOpt types.str "A Computer";
      env = {
        wm = mkInfoOpt;
      };
      stationary = mkBoolOpt false;
      loc = {
        home = mkBoolOpt config.info.stationary;
      };
    };

    secrets = mkOpt (attrsOf path) { };
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

    secrets = mapAttrs (n: v: v.path) config.age.secrets;
  };
}
