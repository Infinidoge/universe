{ private, config, lib, pkgs, ... }:

{
  modules.hardware.form.server = true;

  networking = {
    domain = "cs.purdue.edu";
    hostName = "data";
  };

  user.name = private.variables.purdue-username;

  home = { ... }: {
    home.packages = with pkgs; [
      home-manager
    ];
  };
}
