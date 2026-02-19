{ lib, secrets, ... }:
let
  mkZone =
    file: config:
    {
      inherit file;
      master = true;
      extraConfig = ''
        update-policy {
          grant _1.universe. zonesub ANY;
        };
      '';
    }
    // config;

  mkPrimaryZone = lib.flip mkZone {
    slaves = [
      "216.218.133.2" # slave.dns.he.net
      "128.210.6.103" # daedalus
    ];
  };
in
{
  persist.directories = [
    "/etc/bind"
    "/srv"
  ];

  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.allowedTCPPorts = [ 53 ];

  services.bind = {
    enable = true;
    ipv4Only = true;
    extraConfig = ''
      include "${secrets.dns-universe}";
    '';
    zones = {
      "inx.moe" = mkPrimaryZone "/srv/dns/inx.moe";
      "challenge.inx.moe" = mkZone "/srv/dns/challenge.inx.moe" { };

      "doge-inc.net" = mkPrimaryZone "/srv/dns/doge-inc.net";
      "foxy.software" = mkPrimaryZone "/srv/dns/foxy.software";
      "swedish.fish" = mkPrimaryZone "/srv/dns/swedish.fish";
      "unreliable.email" = mkPrimaryZone "/srv/dns/unreliable.email";
      "vulcan.moe" = mkPrimaryZone "/srv/dns/vulcan.moe";
    };
  };
}
