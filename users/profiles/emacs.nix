{ config, pkgs, lib, ... }: {
  programs.emacs = {
    enable = true;
  };

  services.emacs = {
    enable = true;
    client.enable = true;
  };

  home = {
    sessionPath = [
      "${config.xdg.configHome}/emacs/bin"
    ];

    packages = with pkgs; [
      ripgrep
      coreutils
      cmake
      fd
      fzf
      clang
      mu
      isync
      texlive.combined.scheme-medium
      jq
      gnumake
      shellcheck
      editorconfig-checker
      nodejs
      nodePackages.prettier
      sqlite

      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
    ];

    # activation = { # Works in theory, but times out on rebuild
    #   install_doom_emacs = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    #     if [ ! -d ${config.xdg.configHome}/emacs/bin ]; then
    #       rm -rf ${config.xdg.configHome}/emacs
    #       git clone --depth 1 $VERBOSE_ARG https://github.com/hlissner/doom-emacs ${config.xdg.configHome}/emacs
    #       ${config.xdg.configHome}/emacs/bin/doom -y install --no-config
    #     fi
    #   '';
    # };
  };
}
