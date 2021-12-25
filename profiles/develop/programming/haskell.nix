{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; lib.lists.flatten [
    haskell-language-server
    ghc
    cabal-install

    (with haskellPackages; [
      hoogle

      brittany
      hls-brittany-plugin
    ])

    stack
    # stack2nix
    cabal2nix
  ];
}
