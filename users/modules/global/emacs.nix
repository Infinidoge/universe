{ config, main, pkgs, lib, ... }:
let
  ifGraphical = lib.optionals main.info.graphical;
  ifGraphical' = lib.optional main.info.graphical;
in
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [ vterm pdf-tools emacsql-sqlite ];
    package = pkgs.emacsNativeComp;
  };

  services.emacs = {
    enable = true;
    client.enable = true;
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
      python310Packages.pygments
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
            ;
        })
        biber
      ])

      # :lang markdown
      pandoc
      python310Packages.grip

      # :lang sh
      shellcheck
      shfmt

      # :lang json
      jq

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
    #       git clone --depth 1 $VERBOSE_ARG https://github.com/hlissner/doom-emacs ${config.xdg.configHome}/emacs
    #       ${config.xdg.configHome}/emacs/bin/doom -y install --no-config
    #     fi
    #   '';
    # };
  };
}
