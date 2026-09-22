{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (texliveMedium.withPackages (
      ps: with ps; [
        apa7
        apacite
        biblatex
        biblatex-apa
        biblatex-chicago
        capt-of
        catchfile
        endfloat
        framed
        fvextra
        hanging
        lipsum
        minted
        mleftright
        scalerel
        threeparttable
        upquote
        wrapfig
        xstring
      ]
    ))
    biber
  ];
}
