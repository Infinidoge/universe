{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (texliveMedium.withPackages (
      ps: with ps; [
        acmart
        apa7
        apacite
        biblatex
        biblatex-apa
        biblatex-chicago
        capt-of
        catchfile
        endfloat
        environ
        framed
        fvextra
        hanging
        lipsum
        minted
        mleftright
        scalerel
        threeparttable
        tipa
        totpages
        upquote
        wrapfig
        xstring
        hyperxmp
        ifmtarg
        ncctools
        comment
      ]
    ))
    biber
  ];
}
