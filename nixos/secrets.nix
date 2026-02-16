{
  self,
  lib,
  config,
  pkgs,
  secrets,
  inputs,
  ...
}:
let

  inherit (lib.our) mkOpt;
  inherit (lib.types) attrsOf path;
in
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default

    { options.secrets = mkOpt (attrsOf path) { }; }
  ];

  _module.args.secrets = config.secrets;
  secrets = lib.mapAttrs (_: v: v.path) config.age.secrets;

  age.rekey = {
    storageMode = "local";
    generatedSecretsDir = "${self}/secrets/generated";
    localStorageDir = "${self}/secrets/rekeyed/${config.networking.hostName}";
    agePlugins = with pkgs; [
      age-plugin-fido2-hmac
      age-plugin-yubikey
    ];
  };

  age.rekey.masterIdentities = [
    "${self}/users/infinidoge/keys/primary_age.pub"
    "${self}/users/infinidoge/keys/backup_age.pub"
  ];

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
