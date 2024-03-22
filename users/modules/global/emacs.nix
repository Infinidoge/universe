{ config, main, pkgs, lib, ... }:
let
  ifGraphical = lib.optionals main.info.graphical;
  ifGraphical' = lib.optional main.info.graphical;
in
lib.mkIf main.info.graphical {
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [ vterm pdf-tools emacsql-sqlite ];
    package = pkgs.emacs29;
  };

  services.emacs = {
    enable = true;
    client.enable = true;
    startWithUserSession = false;
  };

  home = {
    sessionPath = [
      "${config.xdg.configHome}/emacs/bin"
    ];

    packages = with pkgs; lib.flatten [
      # --- Doom Emacs ---
      fd
      ripgrep
      fzf
      mlocate

      gnumake

      # --- :tools ---
      # :tools editorconfig
      editorconfig-core-c
      editorconfig-checker

      # --- :app ---
      # :app everywhere
      xdotool
      xclip

      # --- :editor ---
      # :editor format
      nodePackages.prettier

      # --- :lang ---
      # :lang org
      python3Packages.pygments
      ## +gnuplot
      gnuplot
      ## +roam2
      graphviz

      # :lang common-lisp
      sbcl

      # :lang cc
      clang-tools

      # :lang csharp
      dotnetCorePackages.sdk_6_0
      omnisharp-roslyn

      # :lang docker
      dockfmt

      # :lang latex
      (ifGraphical [
        (texlive.combine {
          inherit (texlive)
            scheme-medium

            biblatex
            biblatex-chicago
            capt-of minted
            catchfile
            framed
            fvextra
            lipsum
            upquote
            wrapfig
            xstring
            mleftright
            ;
        })
        biber
      ])

      # :lang markdown
      pandoc
      # python3Packages.grip
      python-grip

      # :lang sh
      shellcheck
      shfmt

      # :lang json
      jq

      # :lang data
      libxml2

      # :lang web
      html-tidy
      stylelint

      # --- :checkers ---
      # :checkers spell
      ## +aspell
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))

      # :checkers grammar
      languagetool
    ];

    # activation = { # Works in theory, but times out on rebuild
    #   install_doom_emacs = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    #     if [ ! -d ${config.xdg.configHome}/emacs/bin ]; then
    #       rm -rf ${config.xdg.configHome}/emacs
    #       git clone --depth 1 $VERBOSE_ARG https://github.com/doomemacs/doomemacs ${config.xdg.configHome}/emacs
    #       ${config.xdg.configHome}/emacs/bin/doom -y install --no-config
    #     fi
    #   '';
    # };
  };
}
