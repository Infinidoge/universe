{ config, pkgs, ... }: {
  programs = {
    bash = {
      enable = true;
      enableVteIntegration = true;
    };

    starship.enableBashIntegration = true;
  };
}
