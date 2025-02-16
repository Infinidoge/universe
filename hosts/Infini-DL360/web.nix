{
  config,
  common,
  pkgs,
  lib,
  ...
}:
with common.nginx;
let
  tryFiles = "$uri $uri.html $uri/ =404";
  websiteConfig = ''
    error_page 403 /403.html;
    error_page 404 /404.html;

    location ^~ /.well-known { allow all; }

    location = /template.html { deny all; }
    location ~* "\.(nix|lock)" { deny all; }
    location ~ "/\..+" { deny all; }
  '';

  mkRedirect = to: ssl-optional // { globalRedirect = to; };
  mkTmpRedirect = to: ssl-optional // { locations."/".return = "302 ${to}"; };
in
{
  services.nginx.commonHttpConfig = ''
    map $request_uri $jump_link {
      default "https://inx.moe";
      volatile;
      include /srv/web/jump.map;
    }
  '';

  services.nginx.virtualHosts = {
    "inx.moe" = ssl-inx // {
      locations."/" = {
        root = "/srv/web/inx.moe";
        inherit tryFiles;
        extraConfig = websiteConfig;
      };
    };
    "nitter.inx.moe" = mkRedirect "twitter.com";
    "sweedish.fish" = mkRedirect "swedish.fish";
    "blahaj.inx.moe" = mkRedirect "swedish.fish";
    "foxy.software" = mkTmpRedirect "https://inx.moe";
    "j.inx.moe" = ssl-inx-optional // {
      locations."/".return = "302 $jump_link";
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
    "files.inx.moe" = ssl-inx // {
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
    "random.inx.moe" = ssl-inx // {
      locations."/" = {
        root = "/srv/web/files.inx.moe/subject";
        extraConfig = ''
          random_index on;
        '';
      };
    };
    "old.inx.moe" = ssl-inx-optional // {
      locations."/" = {
        root = "/srv/web/inx.moe";
        inherit tryFiles;
        extraConfig = websiteConfig;
      };
    };
    "tools.inx.moe" = ssl-inx // {
      locations."/".root = "${pkgs.it-tools}/share";
    };
  };

  services.uwsgi = {
    enable = true;
    plugins = [ "python3" ];
    instance.type = "emperor";
  };
}
