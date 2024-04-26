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
    "files.inx.moe" = ssl // {
      locations."/" = {
        root = "/srv/web/files.inx.moe";
        extraConfig = ''
          autoindex on;
        '';
      };
    };
    "test.inx.moe" = ssl // {
      locations."/" = {
        root = "/srv/web/inx.moe";
        tryFiles = "$uri $uri.html $uri/ =404";
        extraConfig = ''
          deny all;

          error_page 403 404 /404.html;

          location = /template.html { deny all; }
          location /.git { deny all; }

          location = /404.html { allow all; internal; }

          location ~* "\.(html|css|txt)$" { allow all; }
          location ~ "/[^.]+" { allow all; }
          location ~ "/$" { allow all; }
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
