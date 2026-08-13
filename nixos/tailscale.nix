{
  config,
  pkgs,
  lib,
  ...
}:
{
  persist.directories = [
    {
      directory = "/var/lib/tailscale";
      mode = "0700";
    }
  ];

  services.tailscale = {
    enable = true;
    package = pkgs.tailscale-doge;
    openFirewall = true;
    useRoutingFeatures = lib.mkDefault "both";
    extraUpFlags = "--accept-routes --accept-dns=false";
  };

  networking.firewall.trustedInterfaces = [
    "tailscale0"
  ];

  networking.domain = "tailnet.inx.moe";

  networking.search = [ config.networking.domain ];

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];
}
