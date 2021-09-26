{ config, pkgs, ... }: {
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom;
  };

  services.emacs = {
    enable = true;
  };

  # home.sessionPath = [
  #   "${config.xdg.configHome}/emacs/bin"
  # ];
}
