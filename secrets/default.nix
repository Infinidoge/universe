{ lib, self, ... }:
let
  folder = ./.;
  toFile = name: "${folder}/${name}";
  filterSecrets = key: value: value == "regular" && lib.hasSuffix ".age" key;
  filtered = (lib.filterAttrs filterSecrets (builtins.readDir folder));
  secrets = lib.mapAttrs' (n: v: lib.nameValuePair (lib.removeSuffix ".age" n) { file = toFile n; }) filtered;
in
{
  age.secrets = secrets;
}
