{ lib, self, config, ... }:
let
  inherit (lib) filterAttrs nameValuePair hasSuffix removeSuffix mapAttrs mapAttrs' hasAttr mkIf mkMerge optionalAttrs;
  inherit (lib.our) mkOpt;
  inherit (lib.types) bool attrsOf path;

  folder = ./.;
  toFile = name: "${folder}/${name}";
  filterSecrets = key: value: value == "regular" && hasSuffix ".age" key;
  filtered = (filterAttrs filterSecrets (builtins.readDir folder));
  secrets = mapAttrs' (n: v: nameValuePair (removeSuffix ".age" n) { file = toFile n; }) filtered;

  withOwner = name: secret: secret // { owner = name; group = name; };
in
{
  options = {
    modules.secrets.enable = mkOpt bool true;
    secrets = mkOpt (attrsOf path) { };
  };

  config = mkIf config.modules.secrets.enable {
    secrets = mapAttrs (n: v: v.path) config.age.secrets;
    age.secrets = mkMerge [
      { inherit (secrets) "infinidoge-password" "root-password" "binary-cache-private-key"; }
      (mkIf config.services.nginx.enable {
        "inx.moe.pem" = withOwner "nginx" secrets."inx.moe.pem";
        "inx.moe.key" = withOwner "nginx" secrets."inx.moe.key";
      })
      (mkIf config.services.vaultwarden.enable {
        "vaultwarden" = withOwner "vaultwarden" secrets."vaultwarden";
      })
    ];
  };
}
