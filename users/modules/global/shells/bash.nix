{ config, pkgs, ... }: {
  imports = [ ./common.nix ];

  programs = {
    bash = {
      enable = true;
      enableVteIntegration = true;
      initExtra = ''
        source <(kitty + complete setup bash)
      '';
    };

    starship.enableBashIntegration = true;
  };
}
