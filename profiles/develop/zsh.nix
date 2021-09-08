{ ... }: {
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        # Display
        "colorize"
        "colored-man-pages"

        # zsh modifications
        "zsh-interactive-cd"
        "zsh_reload"
        "command-not-found"

        # Aliases
        "alias-finder"

        # Applications
        ## Docker
        "docker"
        ## Python
        "pip"
        "python"
        ## Systemd
        "systemd"
        ## Git
        "git"
        "github"
        "gitignore"
        ## Emacs
        "emacs"
        ## Vim
        "fancy-ctrl-z"
      ];
    };
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "pattern" "cursor" ];
      patterns = { "rm -rf *" = "fg=white,bold,bg=red"; };
    };
    zsh-autoenv.enable = true;
  };
}
