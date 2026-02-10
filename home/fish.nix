{
  programs.fish = {
    enable = true;
    functions = { };
    shellAbbrs = { };
    interactiveShellInit = ''
      kitty + complete setup fish | source
      set -U fish_greeting
    '';
  };
}
