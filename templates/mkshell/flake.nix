{
  description = "mkShell devshell template using flake-parts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        systems = [ "x86_64-linux" ];

        perSystem =
          { pkgs, ... }:
          {
            devshells.default = pkgs.mkShell {
              name = "template";
              packages = with pkgs; [ ];
              buildInputs = with pkgs; [ ];
              shellHook = '''';
            };
          };
      }
    );
}
