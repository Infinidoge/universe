{ config, pkgs, ... }:
let
  inherit (config.common.nginx) ssl ssl-optional;
in
{
  services.nginx.virtualHosts = {
    "blahaj.inx.moe" = ssl-optional // {
      locations."/" = {
        tryFiles = "/Blahaj.png =404";
        root = ./static;
      };
    };

    "ponder.inx.moe" = ssl // {
      locations."/".root = pkgs.ponder;
    };
    "nitter.inx.moe" = ssl // {
      globalRedirect = "twitter.com";
    };
  };
}
