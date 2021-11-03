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
      clang
      cmake
      coreutils
      editorconfig-checker
      fd
      fzf
      gnumake
      isync
      jq
      libvterm
      mu
      nodePackages.prettier
      nodejs
      python39Packages.pygments
      ripgrep
      shellcheck
      sqlite

      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
      (texlive.combine {
        inherit (texlive)
          scheme-medium wrapfig capt-of minted fvextra upquote catchfile xstring framed;
      })
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
