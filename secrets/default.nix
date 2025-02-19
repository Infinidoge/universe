{
  lib,
  config,
  ...
}:
with lib;
let
  inherit (lib.our) mkOpt mkBoolOpt;
  inherit (lib.types) attrsOf path;
  inherit (lib.our.secrets) withGroup;
in
{
  options = {
    modules.secrets.enable = mkBoolOpt true;
    secrets = mkOpt (attrsOf path) { };
  };

  config = mkIf config.modules.secrets.enable {
    _module.args.secrets = config.secrets;
    secrets = mapAttrs (n: v: v.path) config.age.secrets;
    age.secrets = {
      borg-ssh-key.rekeyFile = ./borg-ssh-key.age;
      borg-password = withGroup "borg" ./borg-password.age;
      binary-cache-private-key = withGroup "hydra" ./binary-cache-private-key.age;
      smtp-noreply = withGroup "smtp" ./smtp-noreply.age;
      dns-cloudflare.rekeyFile = ./dns-cloudflare.age;
    };
  };
}
