{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = rec {
      package = (pkgs.nerdfonts.override { fonts = [ name ]; });
      name = "DejaVuSansMono";
      size = 12;
    };
    settings = {
      confirm_os_window_close = 0;
      scrollback_lines = 100000;
    };
    #theme = "Doom One";
  };

  home.shellAliases = {
    #ssh = "kitty +kitten ssh";
    icat = "kitty +kitten icat";
  };
}
