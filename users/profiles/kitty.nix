{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      package = (pkgs.nerdfonts.override { fonts = [ "DejaVuSansMono" ]; });
      name = "DejaVuSansMono";
      size = 12;
    };
    settings = {
      confirm_os_window_close = 0;
    };
  };

  home.shellAliases = {
    ssh = "kitty +kitten ssh";
    softsh = "TERM=xterm-256color \\ssh"; # https://github.com/charmbracelet/soft-serve/issues/72
    icat = "kitty +kitten icat";
  };
}
