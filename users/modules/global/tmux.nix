{ ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
    terminal = "xterm-256color";
    prefix = "C-Space";
  };
}
