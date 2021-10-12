{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; lib.lists.flatten [
    haskell-language-server
    ghc

    stack
    stack2nix
    cabal2nix
  ];
}
