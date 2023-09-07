{ pkgs, lib, ... }: {
  home.packages = with pkgs; lib.lists.flatten [
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
  ];
}
