{ lib, ... }:
let
  inherit (lib.our.secrets) withGroup withOwnerGroup;
in
{
  age.secrets = {
    authentik-ldap.rekeyFile = ./authentik-ldap.age;
    authentik.rekeyFile = ./authentik.age;
    binary-cache-private-key.group = "hydra";
    binary-cache-private-key.mode = "440";
    freshrss = withOwnerGroup "freshrss" ./freshrss.age;
    hedgedoc = withOwnerGroup "hedgedoc" ./hedgedoc.age;
    hydra = withGroup "hydra" ./hydra.age;
    ovpn.rekeyFile = ./ovpn.age;
    radicale-ldap = withOwnerGroup "radicale" ./radicale-ldap.age;
    searx.rekeyFile = ./searx.age;
    vaultwarden.rekeyFile = ./vaultwarden.age;
  };
}
