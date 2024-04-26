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
    "files.inx.moe" = {
      locations."/" = {
        root = "/srv/web/files.inx.moe";
        extraConfig = ''
          autoindex on;
        '';
      };
    };
    "test.inx.moe" = {
      root = "/srv/web/inx.moe";
      locations."/" = {
        tryFiles = "$uri $uri.html =404";
        extraConfig = ''
          deny all;

          location ~ "\.(html|css|txt)" {
            allow all;
          }

          location = /template.html {
            deny all;
          };
        '';
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
