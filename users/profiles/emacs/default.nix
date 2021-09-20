{ config, pkgs, ... }: {
  # programs.doom-emacs = {
  #   enable = true;
  #   doomPrivateDir = ./doom;
  # };

  # services.emacs = {
  #   enable = true;
  #   package = config.programs.emacs.package;
  # };

  home.sessionPath = [
    "${config.xdg.configHome}/emacs/bin"
  ];
}
