# Heavily inspired by hlissner: https://github.com/hlissner/dotfiles/blob/master/modules/options.nix
{ config, options, lib, home-manager, ... }:
with lib;
with lib.hlissner;
let
  mkAliasOpt = mkOpt types.attrs { };
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

    bud.localFlakeClone = config.dotfiles.dir;

    secrets = mapAttrs (n: v: v.path) config.age.secrets;
  };
}
