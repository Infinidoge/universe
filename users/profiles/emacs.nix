{ config, pkgs, lib, ... }: {
  services.emacs.enable = true;

  home = {
    sessionPath = [
      "${config.xdg.configHome}/emacs/bin"
    ];

    packages = with pkgs; [
      emacs
      ripgrep
      coreutils
      cmake
      fd
      fzf
      clang
      mu
      isync
      texlive.combined.scheme-full
      jq
      gnumake
      shellcheck
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
