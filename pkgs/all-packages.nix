{ pkgs }:
rec {
  bytecode-viewer = pkgs.callPackage ./bytecode-viewer.nix { };
  ears-cli = pkgs.callPackage ./ears-cli.nix { };
  fw-ectool = pkgs.callPackage ./fw-ectool.nix { };
  hexagon = pkgs.callPackage ./hexagon.nix { };
  jupyterlab-myst = pkgs.python3Packages.callPackage ./jupyterlab-myst { };
  jupyterlab-vim = pkgs.python3Packages.callPackage ./jupyterlab-vim { };
  mcaselector = pkgs.callPackage ./mcaselector.nix { };
  nix-modrinth-prefetch = pkgs.callPackage ./nix-modrinth-prefetch.nix { };
  olympus = pkgs.callPackage ./olympus.nix { };
  sim65 = pkgs.callPackage ./sim65.nix { };
  substituteSubset = pkgs.callPackage ./substitute-subset.nix { };
  tmx-cups-ppd = pkgs.callPackage ./tmx-cups-ppd.nix { };
  unbted = pkgs.callPackage ./unbted.nix { };
  unmap = pkgs.callPackage ./unmap { };
  vpython-jupyter = pkgs.python3Packages.callPackage ./vpython-jupyter.nix {
    inherit jupyterlab-vpython;
  };
  jupyterlab-vpython = pkgs.python3Packages.callPackage ./jupyterlab-vpython { };
  jupyter-server-proxy = pkgs.python3Packages.callPackage ./jupyter-server-proxy {
    inherit simpervisor;
  };
  simpervisor = pkgs.python3Packages.callPackage ./simpervisor.nix { };
}
