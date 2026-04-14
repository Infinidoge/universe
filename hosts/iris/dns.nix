{ lib, secrets, ... }:
let
  he-dns = "216.218.133.2"; # slave.dns.he.net
  chardns = "45.8.201.114"; # denise.charbroil.me
  konsol = "132.145.164.26"; # ns1.shad.moe
  grace = "152.44.40.91"; # ns1.grace.pink

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
      he-dns
      chardns
      konsol
      grace
      "128.210.6.103" # daedalus
    ];
  };

  mkSecondaryZone = file: masters: {
    inherit file masters;
    master = false;
  };
in
{
  persist.directories = [
    "/etc/bind"
    "/etc/secrets"
    "/srv"
  ];

  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.allowedTCPPorts = [ 53 ];

  services.bind = {
    enable = true;
    ipv4Only = true;
    checkConfig = false; # include files prevent checking config
    extraConfig = ''
      include "${secrets.dns-universe}";
      include "/etc/secrets/dns/vulcan";
    '';
    zones = {
      "inx.moe" = mkPrimaryZone "/srv/dns/inx.moe";
      "challenge.inx.moe" = mkZone "/srv/dns/challenge.inx.moe" { };

      "doge-inc.net" = mkPrimaryZone "/srv/dns/doge-inc.net";
      "foxy.software" = mkPrimaryZone "/srv/dns/foxy.software";
      "swedish.fish" = mkPrimaryZone "/srv/dns/swedish.fish";
      "unreliable.email" = mkPrimaryZone "/srv/dns/unreliable.email";
      "funmafia.industries" = mkPrimaryZone "/srv/dns/funmafia.industries";

      "vulcan.moe" = {
        master = true;
        file = "/srv/dns/vulcan.moe";
        slaves = [
          he-dns
          chardns
          konsol
          grace
        ];
        extraConfig = ''
          update-policy {
            grant _1.vulcan. zonesub ANY;
          };
        '';
      };

      "charbroil.me" = mkSecondaryZone "/srv/saved/charbroil.me" [ chardns ];
      "puppy.observer" = mkSecondaryZone "/srv/saved/puppy.observer" [ chardns ];
      "bdsm.equipment" = mkSecondaryZone "/srv/saved/bdsm.equipment" [ chardns ];
      "ilovehewlettpackard.com" = mkSecondaryZone "/srv/saved/ilovehewlettpackard.com" [ chardns ];

      "shad.moe" = mkSecondaryZone "/srv/saved/shad.moe" [ konsol ];
      "konpeki.solutions" = mkSecondaryZone "/srv/saved/konpeki.solutions" [ konsol ];
      "konpekisolutions.com" = mkSecondaryZone "/srv/saved/konpekisolutions.com" [ konsol ];

      "grace.pink" = mkSecondaryZone "/srv/saved/grace.pink" [ grace ];
      "gae.moe" = mkSecondaryZone "/srv/saved/gae.moe" [ grace ];
    };
  };
}
