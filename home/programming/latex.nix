{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (texliveMedium.withPackages (
      ps: with ps; [
        # pandoc requirements
        amsfonts
        amsmath
        lm
        unicode-math
        iftex
        listings
        fancyvrb
        #longtable
        booktabs
        multirow
        #graphicx
        bookmark
        xcolor
        soul
        geometry
        setspace
        babel
        framed

        # pandoc xelatex/lualatex
        fontspec

        # pandoc xelatex
        xecjk
        bidi
        mathspec

        # pandoc lualatex
        luatexja
        selnolig
        lua-ul

        # pandoc optional
        upquote
        microtype
        csquotes
        parskip
        xurl
        footnotehyper

        # bibliography
        natbib
        biblatex
        bibtex
        biber

        # apa format
        apa7
        apacite
        biblatex-apa

        # chicago format
        biblatex-chicago

        # acm format
        acmart

        # unspecified
        capt-of
        catchfile
        endfloat
        environ
        fvextra
        hanging
        lipsum
        minted
        mleftright
        scalerel
        threeparttable
        tipa
        totpages
        wrapfig
        xstring
        hyperxmp
        ifmtarg
        ncctools
        comment
      ]
    ))
  ];
}
