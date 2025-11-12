let
  pkgs = import <nixpkgs> { };
  devshell = import <devshell> { nixpkgs = pkgs; };
in

devshell.mkShell {
  packages = with pkgs; [ ];
}
