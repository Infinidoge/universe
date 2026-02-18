{
  services.bind = {
    enable = true;
    zones = {
      "inx.moe" = {
        master = true;
        file = "/srv/dns/testing.inx.moe";
      };
    };
  };
}
