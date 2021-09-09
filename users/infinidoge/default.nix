{ config, self, lib, pkgs, ... }: {
  home-manager.users.infinidoge = { suites, ... }: {
    imports = suites.base;

    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;

      settings = { };
    };

    programs.kitty = {
      enable = true;
      font.package = (pkgs.nerdfonts.override { fonts = [ "DejaVuSansMono" ]; });
      font.name = "DejaVuSansMono";
      font.size = 16;
    };

    programs.zsh = {
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
  };

  environment.pathsToLink = [ "/share/zsh" ];

  users.users.infinidoge = {
    uid = 1000;
    hashedPassword =
      "PASSWORD SET IN THE FUTURE";
    description = "Infinidoge";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
}
