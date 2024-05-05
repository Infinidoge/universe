{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."thelounge.inx.moe" = config.common.nginx.ssl // {
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.thelounge.port}";
    };
  };

  services.thelounge = {
    enable = true;
    dataDir = "/srv/thelounge";
    plugins = with pkgs.theLoungePlugins; [
      themes.zenburn-monospace
      themes.dracula
      themes.discordapp
    ];
    port = 9786;
    extraConfig = {
      reverseProxy = true;
    };
  };
}
