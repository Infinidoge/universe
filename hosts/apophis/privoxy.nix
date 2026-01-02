{
  services.privoxy = {
    enable = true;
    settings = {
      listen-address = "100.101.102.1:8118";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8118 ];
}
