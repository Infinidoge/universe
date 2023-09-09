{ config, pkgs, ... }: {
  imports = [ ./common.nix ];

  programs = {
    ion = {
      enable = true;
    };

    starship.enableIonIntegration = true;
  };
}
