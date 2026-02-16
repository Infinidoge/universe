{
  config,
  main,
  pkgs,
  ...
}:
{
  programs.zsh = rec {
    enable = true;

    enableCompletion = true;
    enableVteIntegration = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    #initExtraFirst = ''
    #  [[ $TERM == "tramp" ]] && unsetopt zle && PS1='$ ' && return
    #'';

    initContent = ''
      if which kitty > /dev/null; then
        source <(kitty + complete setup zsh)
      fi
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin

      functions -c precmd precmd_any_nix_shell

      precmd() {
        precmd_any_nix_shell

        if [[ -s ~/TODO.txt && ! -v __TODO_PRINTED ]] then
          export __TODO_PRINTED=1
          if [[ "$(cat ~/TODO.txt)" != "" ]] then
            echo TODO:
            \cat ~/TODO.txt
          fi
        fi
      }
    '';

    dotDir = "${config.xdg.configHome}/zsh";

    history.path = "${dotDir}/.zsh_history";

    shellAliases = builtins.removeAttrs (
      config.home.shellAliases
      // {
        lsdiskw = "while true; do clear; lsdisk; sleep 1; done";
      }
    ) [ "mktmp" ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        # Display
        "colorize"
        "colored-man-pages"

        # zsh modifications
        "zsh-interactive-cd"
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
}
