# Heavily inspired by hlissner: https://github.com/hlissner/dotfiles/blob/master/modules/options.nix
{
  config,
  options,
  lib,
  ...
}:
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
    };

    env = mkAliasOpt;

    info = {
      monitors = mkOpt int 1;
      graphical = mkBoolOpt config.services.xserver.enable;
      model = mkOpt str "A Computer";
      env = {
        wm = mkInfoOpt;
      };
      ip = {
        internal = mkOpt (nullOr str) null;
        external = mkOpt (nullOr str) null;
      };
    };
  };

  config = {
    users.users.${config.user.name} = mkAliasDefinitions options.user;
    home-manager.users.${config.user.name} = mkAliasDefinitions options.home;

    environment.variables = mkAliasDefinitions options.env;
  };
}
