{ secrets, ... }:
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
      include ${secrets.dns-universe};
    '';
    zones = {
      "inx.moe" = {
        master = true;
        file = "/srv/dns/inx.moe";
        slaves = [
          "216.218.133.2" # slave.dns.he.net
          "128.210.6.103" # daedalus
        ];
        extraConfig = ''
          update-policy {
            grant _1.universe. zonesub ANY;
          };
        '';
      };
    };
  };
}
