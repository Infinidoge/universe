{ ... }: {
  programs.vim = {
    enable = true;
    settings = {
      background = "dark";
      directory = [
        "."
        "~/.local/share/vim/swap//"
      ];
      expandtab = true;
      history = 50;
      ignorecase = true;
      smartcase = true;
      mouse = "a";
      number = true;
      tabstop = 4;
      shiftwidth = 4;
    };
  };
}
