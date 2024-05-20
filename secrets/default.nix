{ lib, self, config, ... }:
with lib;
let
  inherit (lib.our) mkOpt;
  inherit (lib.types) bool attrsOf path;

  mkSecret = name: nameValuePair
    (removeSuffix ".age" name)
    { file = "${./.}/${name}"; };
  secrets = listToAttrs (map mkSecret (attrNames (import ./secrets.nix)));

  withOwnerGroup = name: secret: secret // { owner = name; group = name; mode = "440"; };
  withOwner = name: secret: secret // { owner = name; };
  withGroup = name: secret: secret // { group = name; mode = "440"; };
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
          "borg-ssh-key"
          ;

        "borg-password" = secrets."borg-password" // { group = "borg"; mode = "440";};
      }
      (mkIf config.services.nginx.enable {
        inherit (secrets) "cloudflare";
      })
      (mkIf config.services.vaultwarden.enable {
        "vaultwarden" = withOwnerGroup "vaultwarden" secrets."vaultwarden";
      })
      (mkIf config.services.freshrss.enable {
        "freshrss" = withOwnerGroup "freshrss" secrets."freshrss";
      })
      (mkIf config.services.forgejo.enable {
        "smtp-password" = withGroup "smtp" secrets."smtp-password";
      })
      (mkIf config.services.hydra.enable {
        inherit (secrets) hydra;
      })
    ];
  };
}
