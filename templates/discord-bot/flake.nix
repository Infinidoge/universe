{
  description = "Template for Python-based Discord bots";

  inputs = {
    nixpkgs.url = "github:Infinidoge/nixpkgs/feat/disnake";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
    pyproject-nix.url = "github:nix-community/pyproject.nix";

    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    pyproject-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" ];

    imports = with inputs; [
      devshell.flakeModule
    ];

    perSystem = { config, pkgs, ... }:
      let
        project = inputs.pyproject-nix.lib.project.loadPyproject {
          projectRoot = ./.;
        };

        python = pkgs.python3;

      in
      {
        packages.default = (python.pkgs.buildPythonPackage (
          project.renderers.buildPythonPackage { inherit python; }
        )).overrideAttrs { allowSubstitutes = false; preferLocalBuild = true; };

        devshells.default =
          let
            env = python.withPackages (
              project.renderers.withPackages {
                inherit python;
                extraPackages = p: with p; [
                  python-lsp-server
                  python-lsp-ruff
                  pylsp-rope
                  isort
                  black
                ];
              }
            );
          in
          {
            devshell = {
              name = "rename";
              motd = "";

              packages = [
                env
              ];
            };
            env = [
              { name = "PYTHONPATH"; prefix = "${env}/${env.sitePackages}"; }
            ];
          };
      };
  };
}
