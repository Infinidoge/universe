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

  setOwner = name: { owner = name; group = name; };
in
{
  options = {
    modules.secrets.enable = mkOpt bool true;
    secrets = mkOpt (attrsOf path) { };
  };

  config = mkMerge [
    {
      age.secrets = mkIf config.modules.secrets.enable secrets;
      secrets = mapAttrs (n: v: v.path) config.age.secrets;
    }

    # Set ownership of keys
    (mkIf config.services.nginx.enable {
      age.secrets."inx.moe.pem" = setOwner "nginx";
      age.secrets."inx.moe.key" = setOwner "nginx";
    })
    (mkIf config.services.vaultwarden.enable {
      age.secrets."vaultwarden" = setOwner "vaultwarden";
    })
  ];
}
