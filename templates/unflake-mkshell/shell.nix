let
  pkgs = import <nixpkgs> { };
in

pkgs.mkShell {
  name = "template";
  packages = with pkgs; [ ];
  buildInputs = with pkgs; [ ];
  shellHook = "";
}
