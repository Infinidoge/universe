{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerd-fonts.dejavu-sans-mono;
      name = "DejaVuSansMono";
      size = 12;
    };
    settings = {
      confirm_os_window_close = 0;
      scrollback_lines = 100000;
      momentum_scroll = 0;
      touch_scroll_multiplier = 0.5;
      pixel_scroll = "no";
    };
  };

  home.shellAliases = {
    icat = "kitten icat";
  };
}
