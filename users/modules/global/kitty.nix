{ main, pkgs, lib, ... }:
{
  config = lib.mkIf main.info.graphical {
    programs.kitty = {
      enable = true;
      font = {
        package = (pkgs.nerdfonts.override { fonts = [ "DejaVuSansMono" ]; });
        name = "DejaVuSansMono";
        size = 12;
      };
      settings = {
        confirm_os_window_close = 0;
        scrollback_lines = 100000;
      };
    };

    home.shellAliases = {
      ssh = "kitty +kitten ssh";
      icat = "kitty +kitten icat";
    };
  };
}
