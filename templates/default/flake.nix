{
  description = "My standard flake-parts devshell template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";

    devshell.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } ({ ... }: {
    systems = [ "x86_64-linux" ];

    imports = with inputs; [
      devshell.flakeModule
    ];

    perSystem = { pkgs, ... }: {
      devshells.default.devshell = {
        name = "template";
        motd = "";

        packages = with pkgs; [ ];
      };
    };
  });
}
