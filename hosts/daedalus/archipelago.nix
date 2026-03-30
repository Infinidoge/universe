{ common, ... }:
let
  # NOTE: Forwarded on router
  portRange = {
    from = 65500;
    to = 65510;
  };
in
{
  networking.firewall.allowedTCPPortRanges = [ portRange ];
  networking.firewall.allowedUDPPortRanges = [ portRange ];

  services.nginx.virtualHosts."archipelago.inx.moe" = common.nginx.ssl-inx // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:38381";
      proxyWebsockets = true;
    };
  };
}
