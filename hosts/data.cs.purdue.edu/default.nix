{ private, config, lib, pkgs, ... }:

{
  modules.hardware.form.server = true;

  system.stateVersion = "23.11";

  networking = {
    domain = "cs.purdue.edu";
    hostName = "data";
  };

  home-manager.useUserPackages = false;

  user.name = lib.mkForce private.variables.purdue-username;

  home = { ... }: {
    home = {
      packages = with pkgs; [
        home-manager
      ];

      homeDirectory = lib.mkForce "/homes/${config.user.name}";
    };
  };
}
