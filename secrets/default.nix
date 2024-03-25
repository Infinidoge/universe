{ lib, self, config, ... }:
with lib;
let
  inherit (lib.our) mkOpt;
  inherit (lib.types) bool attrsOf path;

  mkSecret = name: nameValuePair
    (removeSuffix ".age" name)
    { file = "${./.}/${name}"; };
  secrets = listToAttrs (map mkSecret (attrNames (import ./secrets.nix)));

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
      {
        inherit (secrets)
          "infinidoge-password"
          "root-password"
          "binary-cache-private-key"
          ;
      }
      (mkIf config.services.nginx.enable {
        "inx.moe.pem" = withOwner "nginx" secrets."inx.moe.pem";
        "inx.moe.key" = withOwner "nginx" secrets."inx.moe.key";
      })
      (mkIf config.services.vaultwarden.enable {
        "vaultwarden" = withOwner "vaultwarden" secrets."vaultwarden";
      })
      (mkIf config.services.freshrss.enable {
        "freshrss" = withOwner "freshrss" secrets."freshrss";
      })
    ];
  };
}
