{ config, pkgs, private, ... }:
{
  imports = [ private.nixosModules.networking ];

  networking = {
    useDHCP = true;
    search = [
      # Tailscale
      "tailnet.inx.moe"
      #"tail4c593.ts.net"
      "nodes.pyro.host"
    ];
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

      # Tailscale
      #"100.100.100.100"
    ];

    firewall.trustedInterfaces = [ "br-+" "tailscale0" ];

    nftables = {
      enable = true;
    };
  };

  services = {
    tailscale = {
      enable = true;
      package = pkgs.tailscale-doge;
      openFirewall = true;
      useRoutingFeatures = if config.info.stationary then "both" else "client";
      extraUpFlags = "--accept-routes --accept-dns=false";
    };

    zerotierone.enable = false;
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];
}
