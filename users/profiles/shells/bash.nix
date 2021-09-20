{ pkgs, ... }: {
  environment.shells = with pkgs; [ bashInteractive ];

  programs = {
    bash = {
      enable = true;
      enableVteIntetration = true;
    };

    starship.enableBashIntegration = true;
  };
}
