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
    sslCert = "${certs}/cert.pem";
    sslKey = "${certs}/key.pem";
    sslCa = "${certs}/chain.pem";
  };

  security.acme.certs."voice.inx.moe" = {
    inherit (config.services.murmur) group;
  };
}
