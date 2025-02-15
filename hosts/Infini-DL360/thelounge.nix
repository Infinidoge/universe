{
  config,
  common,
  pkgs,
  ...
}:

{
  services.nginx.virtualHosts."thelounge.inx.moe" = common.nginx.ssl-inx // {
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
