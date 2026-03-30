{ common, config, ... }:
let
  domain = common.subdomain "rss-bridge";
  cfg = config.services.rss-bridge;
in
{
  persist.directories = [
    {
      directory = cfg.dataDir;
      inherit (cfg) user group;
    }
  ];

  services.nginx.virtualHosts.${domain} = common.nginx.ssl-inx;

  services.rss-bridge = {
    enable = true;
    virtualHost = domain;
    config = {
      system.enabled_bridges = [
        "BlueskyBridge"
        "YoutubeBridge"
        "YouTubeCommunityTabBridge"
      ];
    };
  };
}
