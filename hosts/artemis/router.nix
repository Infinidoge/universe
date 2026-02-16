{
  persist.directories = [
    {
      directory = "/var/lib/dnsmasq/";
      user = "dnsmasq";
    }
  ];

  specialisation.router.configuration = {
    networking = {
      bridges.br0.interfaces = [
        "enp0s13f0u1"
        #"wlp170s0-ap0"
      ];
      interfaces."br0".ipv4.addresses = [
        {
          address = "192.168.100.1";
          prefixLength = 24;
        }
      ];

      firewall.interfaces."br0" = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [
          53
          67
        ];
      };

      nat = {
        enable = true;
        internalInterfaces = [ "br0" ];
        externalInterface = "wlp170s0";
      };
    };

    #networking.wireless.extraConfig = ''
    #  freq_list=2462
    #'';

    #services.hostapd = {
    #  enable = true;
    #  radios."wlp170s0-ap0" = {
    #    band = "2g";
    #    channel = 11;
    #    networks."wlp170s0-ap0" = {
    #      ssid = "Artemis";
    #      authentication = {
    #        mode = "wpa2-sha1";
    #        # If you find me IRL, enjoy the WiFi I guess
    #        wpaPassword = "jointhehunt";
    #      };
    #    };
    #  };
    #};

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

        dhcp-host = "192.168.100.1";
        dhcp-range = "192.168.100.10,192.168.100.100";
        interface = [ "br0" ];

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
