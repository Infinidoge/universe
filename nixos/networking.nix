{
  networking = {
    useDHCP = true;
    nameservers = [
      # Google Public DNS
      "8.8.8.8"
      "8.8.4.4"
      "2001:4860:4860::8888"
      "2001:4860:4860::8844"

      # Cloudflare Public DNS
      "1.1.1.1"
      "1.0.0.1"
      "2696:4700:4700::1111"
      "2696:4700:4700::1111"
    ];

    firewall.trustedInterfaces = [
      "br-+"
    ];

    nftables.enable = true;
  };

  services.fail2ban.ignoreIP = [
    "100.101.102.0/14" # Tailscale
    "172.16.0.0/12" # Docker/Containers
    "10.0.0.0/8" # Private networks
    "100.64.0.0/10" # CGNAT
    "192.168.1.0/24" # Private networks
    "192.168.137.0/24" # Rack network
    "128.46.0.0/16" # Purdue
  ];
}
