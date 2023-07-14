{ config, lib, pkgs, main, ... }: {
  imports = [ ./common.nix ];

  programs = {
    zsh = rec {
      enable = true;

      enableCompletion = true;
      enableVteIntegration = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;

      # defaultKeymap = "emacs";

      initExtraFirst = ''
        [[ $TERM == "tramp" ]] && unsetopt zle && PS1='$ ' && return
      '';

      initExtra = ''
        ${pkgs.kitty}/bin/kitty + complete setup zsh | source /dev/stdin
        ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
        if [[ -e ~/TODO.txt && ! -v __TODO_PRINTED ]] then
          export __TODO_PRINTED=1
          echo TODO:
          \cat ~/TODO.txt
        fi
      '';

      dotDir = ".config/zsh";

      history.path = "/home/infinidoge/${dotDir}/.zsh_history";

      shellAliases = main.environment.shellAliases // config.home.shellAliases;

      oh-my-zsh = {
        enable = true;
        plugins = [
          # Display
          "colorize"
          "colored-man-pages"

          # zsh modifications
          "zsh-interactive-cd"
          "command-not-found"
          "sudo"

          # Aliases
          "alias-finder"

          # Applications
          ## Python
          "pip"
          ## Git
          "gitignore"
          ## Vim
          "fancy-ctrl-z"
        ];
      };
    };

    starship.enableZshIntegration = lib.mkIf config.programs.starship.enable true;
  };
}
