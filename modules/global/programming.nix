{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) flip;
  inherit (lib.our) mkBoolOpt' addPackageLists;

  cfg = config.universe.programming;

  programmingOpt' = kind: flip mkBoolOpt' "Programming: ${kind}";
  programmingOpt = flip programmingOpt' cfg.all.enable;
in
{
  options.universe.programming =
    (addPackageLists {
      base.enable = programmingOpt' "Base packages" true;

      c.enable = programmingOpt' "C" true;
      csharp.enable = programmingOpt "C#";
      haskell.enable = programmingOpt "Haskell";
      java.enable = programmingOpt "Java";
      lua.enable = programmingOpt "Lua";
      nim.enable = programmingOpt "Nim";
      python.enable = programmingOpt' "Python" true;
      racket.enable = programmingOpt "Racket";
      rust.enable = programmingOpt "Rust";
      zig.enable = programmingOpt "Zig";
      latex.enable = programmingOpt "LaTeX";
      html.enable = programmingOpt "HTML";
    })
    // {
      all.enable = programmingOpt' "All languages" false;
    };

  config = {
    universe.programming = with pkgs; {
      base.packages = [
        editorconfig-core-c
        editorconfig-checker
      ];

      c.packages = [
        gcc
        gdb
        clang-tools
        binutils
      ];

      csharp.packages = [
        dotnetCorePackages.sdk_8_0
        omnisharp-roslyn
      ];

      haskell.packages = with haskellPackages; [
        ghc
        cabal-install
        ormolu

        hoogle

        stack
        # stack2nix
        cabal2nix
      ];

      java.packages = [
        openjdk
        clang-tools
        gradle
      ];

      lua.packages = [
      ];

      nim.packages = [
        nim
      ];

      python.packages = [
        (python312.withPackages (
          p: with p; [
            black
            isort
            jupyter
            mypy
            parallel-ssh
            pip
            pyflakes
            pytest
          ]
        ))
        pipenv
        ruff
      ];

      racket.packages = [
        racket
      ];

      rust.packages = [
        (rust-bin.selectLatestNightlyWith (
          toolchain:
          toolchain.default.override {
            extensions = [
              "rust-src"
              "rust-analyzer"
            ];
          }
        ))
        gcc
      ];

      zig.packages = [
        zig
        zls
      ];

      latex.packages = [
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

      html.packages = [
        html-tidy
        nodePackages.prettier
      ];
    };

    universe.packages = lib.concatMap (v: lib.optionals (v ? packages && v.enable) v.packages) (
      lib.attrValues cfg
    );

    programs.java.enable = cfg.java.enable;

  };

}
