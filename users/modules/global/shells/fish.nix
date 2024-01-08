{ config, lib, pkgs, ... }: {
  imports = [ ./common.nix ];

  programs = {
    fish = {
      enable = true;
      functions = { };
      shellAbbrs = { };
      interactiveShellInit = ''
        kitty + complete setup fish | source
        set -U fish_greeting
      '';
    };

    starship.enableFishIntegration = lib.mkIf config.programs.starship.enable true;
  };
}
