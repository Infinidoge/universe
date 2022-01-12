{ config, pkgs, lib, ... }: {
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [ vterm ];
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
      fd
      fzf
      gnumake
      isync
      jq
      mu
      nodePackages.prettier
      nodejs
      perl
      python39Packages.pygments
      ripgrep
      shellcheck
      sqlite

      # --- :tools ---
      # :tools editorconfig
      editorconfig-core-c
      editorconfig-checker

      # --- :app ---
      # :app everywhere
      xdotool
      xclip

      # --- :lang ---
      # :lang org
      ## +gnuplot
      gnuplot
      ## +roam2
      graphviz

      # :lang common-lisp
      sbcl

      # :lang csharp
      mono
      omnisharp-roslyn

      # :lang latex
      (texlive.combine {
        inherit (texlive)
          scheme-medium wrapfig capt-of minted fvextra upquote catchfile xstring framed;
      })

      # :lang markdown
      pandoc
      python39Packages.grip

      # --- :checkers ---
      # :checkers spell
      ## +aspell
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
