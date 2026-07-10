{ config, ... }:

let
  certs = config.security.acme.certs."voice.inx.moe".directory;
in

{
  services.murmur = {
    enable = true;
    openFirewall = true;
    password = "shmoopy";
    stateDir = "/srv/murmur";
    tls.certPath = "${certs}/cert.pem";
    tls.keyPath = "${certs}/key.pem";
    tls.caPath = "${certs}/chain.pem";
  };

  security.acme.certs."voice.inx.moe" = {
    inherit (config.services.murmur) group;
  };
}
