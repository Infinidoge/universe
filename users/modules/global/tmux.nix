{ ... }: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "screen-256color";
    prefix = "C-Space";

    extraConfig = ''
      set -g mouse on
    '';
  };
}
