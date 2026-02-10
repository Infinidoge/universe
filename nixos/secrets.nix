{
  self,
  lib,
  config,
  secrets,
  ...
}:
let

  inherit (lib.our) mkOpt;
  inherit (lib.types) attrsOf path;
in
{
  imports = [
    { options.secrets = mkOpt (attrsOf path) { }; }
  ];

  _module.args.secrets = config.secrets;
  secrets = lib.mapAttrs (_: v: v.path) config.age.secrets;

  age.secrets = {
    password-infinidoge.rekeyFile = "${self}/secrets/password-infinidoge.age";
    password-root.rekeyFile = "${self}/secrets/password-root.age";
    binary-cache-private-key.rekeyFile = "${self}/secrets/binary-cache-private-key.age";
  };

  users.users.infinidoge.hashedPasswordFile = secrets.password-infinidoge;
  users.users.root.hashedPasswordFile = secrets.password-root;
  nix.settings.secret-key-files = secrets.binary-cache-private-key;

  age.generators = {
    envfile =
      {
        lib,
        decrypt,
        deps,
        ...
      }:
      lib.concatMapAttrsStringSep "\n" (name: secret: ''
        printf '${name}="%s"\n' $(${decrypt} ${lib.escapeShellArg secret.file})
      '') deps;

    hex32 = { pkgs, ... }: "${pkgs.openssl}/bin/openssl rand -hex 32";
  };
}
