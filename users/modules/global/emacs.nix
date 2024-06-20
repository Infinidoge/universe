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
  };

  home = {
    sessionPath = [
      "${config.xdg.configHome}/emacs/bin"
    ];

    packages = with pkgs; lib.flatten [
      # --- Doom Emacs ---
      mlocate

      gnumake

      # --- :tools ---
      # :tools editorconfig
      editorconfig-core-c
      editorconfig-checker

      # --- :editor ---
      # :editor format
      nodePackages.prettier

      # --- :lang ---
      # :lang org
      python3Packages.pygments
      ## +gnuplot
      gnuplot
      ## +roam2

      # :lang common-lisp
      sbcl

      # :lang docker
      dockfmt

      # :lang latex
      (ifGraphical [
        (texlive.combine {
          inherit (texlive)
            scheme-medium

            apa7
            apacite
            biblatex
            biblatex-apa
            biblatex-chicago
            capt-of minted
            catchfile
            endfloat
            framed
            fvextra
            hanging
            lipsum
            mleftright
            scalerel
            threeparttable
            upquote
            wrapfig
            xstring
            ;
        })
        biber
      ])

      # :lang markdown
      # python3Packages.grip
      python-grip

      # :lang sh
      shellcheck
      shfmt

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
  };
}
