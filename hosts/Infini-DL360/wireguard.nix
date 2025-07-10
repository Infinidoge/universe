{ pkgs, ... }:
let
  subnet = "192.168.200.0/24";
in

{
  networking.wireguard.enable = true;

  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall.allowedUDPPorts = [ 51820 ];

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "192.168.200.1/24" ];
      listenPort = 51820;

      privateKeyFile = "/etc/secrets/wireguard/private";

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${subnet} -o br0 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${subnet} -o br0 -j MASQUERADE
      '';
    };
  };
}
