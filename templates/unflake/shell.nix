let
  pkgs = import <nixpkgs> { };
  devshell = import <devshell> { };
in

devshell.mkShell {
  packages = with pkgs; [ ];
}
