{ config, pkgs, ... }: {
  programs = {
    bash = {
      enable = true;
      enableVteIntetration = true;
    };

    starship.enableBashIntegration = true;
  };

  config.environment.shells = with pkgs; [ bashInteractive ];
}
