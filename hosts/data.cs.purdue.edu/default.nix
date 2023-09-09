{ config, lib, pkgs, ... }:

{
  modules.hardware.form.server = true;

  networking = {
    domain = "cs.purdue.edu";
    hostName = "data";
  };

  home = { ... }: {
    home.packages = with pkgs; [
      home-manager
    ];
  };
}
