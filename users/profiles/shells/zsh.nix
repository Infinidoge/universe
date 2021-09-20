{ config, lib, pkgs, ... }: {
  programs = {
    zsh = {
      enable = true;

      enableCompletion = true;
      enableVteIntegration = true;

      initExtra = ''
        kitty + complete setup zsh | source /dev/stdin
      '';
      # autosuggestions.enable = true;

      # syntaxHighlighting = {
      #   enable = true;
      #   highlighters = [ "main" "brackets" "pattern" "cursor" ];
      #   patterns = {
      #     "rm -rf *" = "fg=white,bold,bg=red";
      #   };
      # };

      # zsh-autoenv.enable = true;

      dotDir = ".config/zsh";

      history.path = "${dotDir}/.zsh_history";

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
