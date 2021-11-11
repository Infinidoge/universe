{ ... }: {
  programs.nushell = {
    enable = true;
    settings = {
      complete_from_path = true;
      ctrlc_exit = true;
      startup = [
        "mkdir ~/.cache/starship"
        "starship init nu | save ~/.cache/starship/init.nu"
        "source ~/.cache/starship/init.nu"
      ];
      prompt = "starship_prompt";
    };
  };
}
