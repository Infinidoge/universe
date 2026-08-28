{
  self,
  config,
  common,
  pkgs,
  ...
}:

{
  imports = [
    self.vendored.nixos.thelounge
  ];

  services.nginx.virtualHosts."thelounge.inx.moe" = common.nginx.ssl-inx // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.thelounge.port}";
    };
  };

  services.thelounge = {
    enable = true;
    dataDir = "/srv/thelounge";

    # BUG: Removed from Nixpkgs
    # https://github.com/NixOS/nixpkgs/pull/389425
    # https://github.com/NixOS/nixpkgs/pull/446123
    # plugins = with pkgs.stable.theLoungePlugins; [
    #   themes.zenburn-monospace
    #   themes.dracula
    #   themes.discordapp
    # ];

    port = 9786;
    extraConfig = {
      reverseProxy = true;
      prefetch = true;
      fileUpload.enable = true;
    };
  };
}
