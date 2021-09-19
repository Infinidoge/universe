{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      package = (pkgs.nerdfonts.override { fonts = [ "DejaVuSansMono" ]; });
      name = "DejaVuSansMono";
      size = 10;
    };
  };

  environment.shellAliases.ssh = "kitty +kitten ssh";
}
