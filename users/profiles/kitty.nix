{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      package = (pkgs.nerdfonts.override { fonts = [ "DejaVuSansMono" ]; });
      name = "DejaVuSansMono";
      size = 12;
    };
  };

  home.shellAliases = {
    ssh = "kitty +kitten ssh";
  };
}
