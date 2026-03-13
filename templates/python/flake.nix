{
  description = "Template for general Python projects";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    pyproject-nix.url = "github:pyproject-nix/pyproject.nix";
    uv2nix.url = "github:pyproject-nix/uv2nix";
    pyproject-build-systems.url = "github:pyproject-nix/build-system-pkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";

    # follows
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    pyproject-build-systems.inputs.nixpkgs.follows = "nixpkgs";
    pyproject-build-systems.inputs.pyproject-nix.follows = "pyproject-nix";
    pyproject-build-systems.inputs.uv2nix.follows = "uv2nix";
    pyproject-nix.inputs.nixpkgs.follows = "nixpkgs";
    uv2nix.inputs.nixpkgs.follows = "nixpkgs";
    uv2nix.inputs.pyproject-nix.follows = "pyproject-nix";
  };

  outputs =
    { self, ... }@inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = with inputs; [
        devshell.flakeModule
      ];

      perSystem =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        let
          # NOTE: Must be the name of the Python module
          projectName = "rename";

          workspace = inputs.uv2nix.lib.workspace.loadWorkspace {
            workspaceRoot = ./.;
          };

          overlay = workspace.mkPyprojectOverlay {
            sourcePreference = "wheel";
          };
          editableOverlay = workspace.mkEditablePyprojectOverlay {
            root = "$PRJ_ROOT";
            members = [ projectName ];
          };

          python = pkgs.python314;

          pythonSetBase = pkgs.callPackage inputs.pyproject-nix.build.packages {
            inherit python;
          };

          pythonSet = pythonSetBase.overrideScope (
            lib.composeManyExtensions [
              inputs.pyproject-build-systems.overlays.wheel
              overlay
            ]
          );

          pythonSetEditable = pythonSet.overrideScope (
            lib.composeManyExtensions [
              editableOverlay
              (final: prev: {
                # https://pyproject-nix.github.io/uv2nix/patterns/source-filtering.html
                ${projectName} = prev.${projectName}.overrideAttrs (old: {
                  src = lib.fileset.toSource rec {
                    root = ./.;
                    fileset = lib.fileset.unions [
                      (root + "/pyproject.toml")
                      (root + "/${projectName}/__init__.py")
                    ];
                  };
                });
              })
            ]
          );
          virtualenv = pythonSetEditable.mkVirtualEnv "${projectName}-dev-env" workspace.deps.all;

          inherit (pkgs.callPackage inputs.pyproject-nix.build.util { }) mkApplication;

        in
        {
          devshells.default = {
            devshell = {
              name = projectName;
              motd = "";
              packages = [
                virtualenv
              ]
              ++ (with pkgs; [
                uv
              ]);
              startup.virtualenv.text = ''
                source ${virtualenv}/bin/activate
              '';
            };

            env = [
              {
                name = "UV_NO_SYNC";
                value = "1";
              }
              {
                name = "UV_PYTHON";
                value = pythonSetEditable.python.interpreter;
              }
              {
                name = "UV_PYTHON_DOWNLOADS";
                value = "never";
              }
              {
                name = "PYTHONPATH";
                unset = true;
              }
            ];
          };

          packages = {
            venv = pythonSet.mkVirtualEnv "${projectName}-env" workspace.deps.default;
            default = mkApplication {
              venv = config.packages.venv;
              package = pythonSet.${projectName};
            };
          };
        };
    };
}
