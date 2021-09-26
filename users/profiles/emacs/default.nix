{ config, pkgs, ... }: {
  services.emacs = {
    enable = true;
  };

  home.sessionPath = [
    "${config.xdg.configHome}/emacs/bin"
  ];
}
