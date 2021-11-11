{ ... }: {
  programs.nushell = {
    enable = true;
    settings = {
      complete_from_path = true;
      ctrlc_exit = true;
      prompt = "STARSHIP_SHELL= starship prompt";
    };
  };
}
