{
  services.bind = {
    enable = true;
    zones = {
      "inx.moe" = {
        master = true;
        file = "/srv/dns/inx.moe";
        slaves = [
          "216.218.133.2" # slave.dns.he.net
          "128.210.6.103" # daedalus
        ];
      };
    };
  };
}
