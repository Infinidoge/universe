{
  persist.directories = [
    {
      directory = "/var/lib/dnsmasq/";
      user = "dnsmasq";
    }
  ];

  specialisation.router.configuration = {
    networking = {
      interfaces."enp0s13f0u1" = {
        ipv4.addresses = [
          {
            address = "192.168.100.1";
            prefixLength = 24;
          }
        ];
      };

      firewall.interfaces."enp0s13f0u1" = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [
          53
          67
        ];
      };

      nat = {
        enable = true;
        internalInterfaces = [ "enp0s13f0u1" ];
        externalInterface = "wlp170s0";
      };
    };

    services.dnsmasq = {
      enable = true;
      settings = {
        server = [
          "8.8.8.8"
          "1.1.1.1"
        ];
        domain-needed = true;
        bogus-priv = true;
        no-resolv = true;

        cache-size = 1000;

        dhcp-range = [ "enp0s13f0u1,192.168.100.10,192.168.100.100" ];
        interface = "enp0s13f0u1";
        dhcp-host = "192.168.100.1";

        local = "/lan/";
        domain = "lan";
        expand-hosts = true;

        no-hosts = true;
        address = "/artemis.lan/192.168.100.1";
      };
    };

    boot.kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };
  };
}
