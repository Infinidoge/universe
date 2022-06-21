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
    icat = "kitty +kitten icat";
  };
}
