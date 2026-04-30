{ pkgs }:
rec {
  it-tools = pkgs.callPackage ./it-tools.nix { };
  vpython-jupyter = pkgs.python3Packages.callPackage ./vpython-jupyter.nix {
    inherit jupyterlab-vpython;
  };
  jupyterlab-vpython = pkgs.python3Packages.callPackage ./jupyterlab-vpython { };
}
