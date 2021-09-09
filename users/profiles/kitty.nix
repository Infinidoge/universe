{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font.package = (pkgs.nerdfonts.override { fonts = [ "DejaVuSansMono" ]; });
    font.name = "DejaVuSansMono";
    font.size = 16;
  };
}
