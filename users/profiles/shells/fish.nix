{ config, lib, pkgs, ... }: {
  programs = {
    fish = {
      enable = true;
      functions = { };
      shellAbbrs = { };
    };

    starship.enableFishIntegration = lib.mkIf config.programs.starship.enable true;
  };
}
