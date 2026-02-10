{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (texlive.combine {
      inherit (texlive)
        scheme-medium

        apa7
        apacite
        biblatex
        biblatex-apa
        biblatex-chicago
        capt-of
        minted
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
  ];
}
