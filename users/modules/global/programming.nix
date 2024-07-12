{ pkgs, lib, ... }:
let
  inherit (lib) flatten;
in
{
  home.packages = with pkgs; flatten [
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
    python311
    (with python311Packages; [
      black
      isort
      jupyter
      mypy
      nose
      pip
      pyflakes
      pyls-isort
      pytest
    ])
    pyright
    pipenv

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
  ];
}
