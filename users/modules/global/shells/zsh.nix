{ config, main, pkgs, ... }:
{
  programs.zsh = rec {
    enable = true;

    enableCompletion = true;
    enableVteIntegration = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtraFirst = ''
      [[ $TERM == "tramp" ]] && unsetopt zle && PS1='$ ' && return
    '';

    initExtra = ''
      ${pkgs.kitty}/bin/kitty + complete setup zsh | source /dev/stdin
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

      if [[ "$(basename "$(readlink "/proc/$PPID/exe")")" == ".kitty-wrapped" ]]; then
        PATH=$(echo "$PATH" | sed 's/\/nix\/store\/[a-zA-Z._0-9+-]\+\/bin:\?//g' | sed 's/:$//')
      fi

      j() {
        if [[ $# -eq 0 ]] then
          \builtin cd -- "$(fd -H -t d | fzf --filepath-word)"
        else
          \builtin cd -- "$(fd -H -t d | fzf --filepath-word -1 -q "$*")"
        fi
      }

      alias "jh"="cd ~ && j"
      alias "gj"="gcd && j"

      mktmpunzip() {
        dir=$(mktemp -t -d unzip.XXX)
        if ! file=$(realpath -e "$1"); then
          echo "error: file does not exist"
          return 1
        fi
        shift 1
        unzip "$file" "$@" -d "$dir"
        \builtin cd $dir
        mv $file .
      }

      mktmpclone() {
        location="$1"
        if [ "$2" != "" ]; then
          dirspec="$2.XXX"
          shift 2
        else
          dirspec="clone.XXX"
          shift 1
        fi
        if ! dir=$(mktemp -t -d "$dirspec"); then
          echo "error: couldn't create temp directory"
          return 1
        fi

        git clone "$location" "$dir" "$@"
        \builtin cd "$dir"
      }
    '';

    dotDir = ".config/zsh";

    history.path = "$HOME/${dotDir}/.zsh_history";

    shellAliases = main.environment.shellAliases // config.home.shellAliases // {
      lsdiskw = "while true; do clear; lsdisk; sleep 1; done";
    };

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
