{ lib, ... }:
let
  mkTemplate = name:
    let
      path = ./. + "/${name}";
      flake = import (path + "/flake.nix");
    in
    { inherit path; }
    // lib.optionalAttrs (flake ? description) { inherit (flake) description; };

  templates = lib.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./.));
in
{
  flake.templates = lib.genAttrs templates mkTemplate;
}
