{ lib, self, config, ... }:
let
  folder = ./.;
  toFile = name: "${folder}/${name}";
  filterSecrets = key: value: value == "regular" && lib.hasSuffix ".age" key;
  filtered = (lib.filterAttrs filterSecrets (builtins.readDir folder));
  secrets = lib.mapAttrs' (n: v: lib.nameValuePair (lib.removeSuffix ".age" n) { file = toFile n; }) filtered;
in
{
  options.modules.secrets.enable = lib.our.mkOpt lib.types.bool true;

  config.age.secrets = lib.mkIf config.modules.secrets.enable secrets;
}
