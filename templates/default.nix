{ lib, ... }:
let
  mkTemplate = name:
    let
      path = ./. + "/${name}";
      flakePath = path + "/flake.nix";
      meta = if builtins.pathExists flakePath then import flakePath else { };
    in
    { inherit path; }
    // lib.optionalAttrs (meta ? description) { inherit (meta) description; };

  templates = lib.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./.));
in
{
  flake.templates = lib.genAttrs templates mkTemplate;
}
