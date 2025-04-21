{ lib }:
let
  inherit (lib) mkOption types flatten;
in
rec {
  mkOpt = type: default: mkOption { inherit type default; };

  mkOpt' =
    type: default: description:
    mkOption { inherit type default description; };

  mkBoolOpt =
    default:
    mkOption {
      inherit default;
      type = types.bool;
      example = true;
    };

  mkBoolOpt' =
    default: description:
    mkOption {
      inherit default description;
      type = types.bool;
      example = true;
    };

  coercedPackageList =
    with types;
    let
      packageListType = listOf (either package packageListType);
    in
    coercedTo packageListType flatten (listOf package);

  coercedPackageListFunction =
    with types;
    coercedTo coercedPackageList (v: (_: v)) (functionTo coercedPackageList);

  packageListOpt = mkOpt coercedPackageList [ ];
  packageListFunctionOpt = mkOpt coercedPackageListFunction [ ];

  addPackageLists = lib.mapAttrs (
    name: value:
    value
    // {
      packages = packageListOpt;
    }
  );
}
