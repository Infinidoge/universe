{ config, lib, ... }: {
  programs = {
    zsh = {
      enable = true;

      enableCompletion = true;
      # enableSyntaxHighlighting = true;
      enableVteIntegration = true;

      dotDir = ".config/zsh";

      history.path = "$ZDOTDIR/.zsh_history";

      oh-my-zsh = {
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
    };

    starship.enableZshIntegration = lib.mkIf config.programs.starship.enable true;
  };
}
