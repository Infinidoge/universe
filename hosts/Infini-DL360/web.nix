{ config, common, pkgs, lib, ... }:
let
  inherit (common.nginx) ssl ssl-optional;

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
  ]
    mkWebsite;

  redirects = lib.mapAttrs mkRedirect {
    "nitter.inx.moe" = "twitter.com";
    "sweedish.fish" = "swedish.fish";
  };
in
{
  services.nginx.commonHttpConfig = ''
    map $request_uri $jump_link {
      default "https://inx.moe";
      volatile;
      include /srv/web/jump.map;
    }
  '';

  services.nginx.virtualHosts = websites // redirects // {
    "j.inx.moe" = ssl-optional // {
      locations."/" = {
        return = "302 $jump_link";
      };
    };
    "blahaj.inx.moe" = ssl-optional // {
      locations."/" = {
        tryFiles = "/Blahaj.png =404";
        root = ./static;
      };
      locations."/buy" = {
        return = "301 https://www.ikea.com/us/en/p/blahaj-soft-toy-shark-90373590/";
      };
    };
    "swedish.fish" = ssl-optional // {
      locations."/" = {
        tryFiles = "/Blahaj.png =404";
        root = ./static;
      };
      locations."/buy" = {
        return = "301 https://www.ikea.com/us/en/p/blahaj-soft-toy-shark-90373590/";
      };
    };
    "files.inx.moe" = ssl // {
      locations."/" = {
        root = "/srv/web/files.inx.moe";
        extraConfig = ''
          autoindex on;
        '';
      };
      locations."/p/" = {
        root = "/srv/web/files.inx.moe";
      };
    };
    "old.inx.moe" = ssl-optional // {
      locations."/" = {
        root = "/srv/web/inx.moe";
        inherit tryFiles;
        extraConfig = websiteConfig;
      };
    };
    "foxy.software" = ssl-optional // {
      locations."/".return = "301 https://inx.moe";
    };
  };

  services.uwsgi = {
    enable = true;
    plugins = [ "python3" ];
    instance.type = "emperor";
  };
}
