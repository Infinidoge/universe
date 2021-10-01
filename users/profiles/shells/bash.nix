{ config, pkgs, ... }: {
  imports = [ ./common.nix ];

  programs = {
    bash = {
      enable = true;
      enableVteIntegration = true;
    };

    starship.enableBashIntegration = true;
  };
}
