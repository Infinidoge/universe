{ config, pkgs, lib, ... }:
let
  inherit (config.common.nginx) ssl ssl-optional;

  tryFiles = "$uri $uri.html $uri/ =404";
  websiteConfig = ''
    error_page 403 /403.html;
    error_page 404 /404.html;

    location ^~ /.well-known { allow all; }

    location = /template.html { deny all; }
    location ~* "\.(nix|lock)" { deny all; }
    location ~ "/\..+" { deny all; }
  '';

  mkWebsite = name: ssl // {
    locations."/" = {
      root = "/srv/web/${name}";
      inherit tryFiles;
      extraConfig = websiteConfig;
    };
  };

  mkRedirect = from: to: ssl-optional // { globalRedirect = to; };

  websites = lib.genAttrs [
    "inx.moe"
    "stickers.inx.moe"
  ] mkWebsite;

  redirects = lib.mapAttrs mkRedirect {
    "nitter.inx.moe" = "twitter.com";
  };
in
{
  services.nginx.virtualHosts = websites // redirects // {
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
        inherit tryFiles;
        extraConfig = websiteConfig;
      };
    };

    "ponder.inx.moe" = ssl // {
      locations."/".root = pkgs.ponder;
    };
  };
}
