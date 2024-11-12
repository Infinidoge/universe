{ pkgs, lib, ... }:
let
  inherit (lib) flatten;
in
{
  home.packages = with pkgs; flatten [
    editorconfig-core-c
    editorconfig-checker

    # C
    gcc
    gdb
    clang-tools
    binutils

    # C Sharp
    dotnetCorePackages.sdk_6_0
    omnisharp-roslyn

    # Haskell
    haskell-language-server
    ghc
    cabal-install
    ormolu

    (with haskellPackages; [
      hoogle
    ])

    stack
    # stack2nix
    cabal2nix

    # Java
    openjdk
    clang-tools
    gradle

    # Lua
    lua-language-server

    # Nim
    nim
    nimlsp

    # Python
    (python312.withPackages (p: with p; [
      black
      isort
      jupyter
      mypy
      nose
      pip
      pyflakes
      pytest

      python-lsp-server
      python-lsp-ruff
      pylsp-rope
      pyls-isort
    ]))
    pipenv
    ruff

    # Racket
    racket

    # Rust
    (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
      extensions = [
        "rust-src"
        "rust-analyzer"
      ];
    }))
    gcc

    # Zig
    zig
    zls

    # LaTeX
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

    # html
    html-tidy
    nodePackages.prettier
  ];

  programs.java.enable = true;
}
