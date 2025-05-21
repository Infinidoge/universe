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
  csp = rec {
    default-src = [
      "'self'"
      "'unsafe-inline'"
    ];
    frame-ancestors = [
      "'self'"
    ];
    script-src = default-src ++ [
      "storage.ko-fi.com"
    ];
    style-src = default-src ++ [
      "fonts.googleapis.com"
    ];
    img-src = [
      "'self'"
      "storage.ko-fi.com"
    ];
    font-src = [
      "'self'"
      "fonts.gstatic.com"
    ];
    frame-src = [
      "'self'"
      "github.com"
    ];
  };
  cspString = lib.concatStringsSep " " (
    lib.mapAttrsToList (kind: locations: "${kind} ${lib.concatStringsSep " " locations};") csp
  );

  websiteConfig = ''
    error_page 403 /403.html;
    error_page 404 /404.html;

    location ^~ /.well-known { allow all; }

    location = /template.html { deny all; }
    location ~* "\.(nix|lock)" { deny all; }
    location ~ "/\..+" { deny all; }

    add_header Content-Security-Policy "${cspString}";
    add_header X-Content-Type-Options "nosniff;";
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
        root = "/srv/web/inx.moe/out"; # TODO: Make this less volatile
        inherit tryFiles;
        extraConfig =
          websiteConfig
          + ''
            add_header Strict-Transport-Security "max-age=2592000;";
          '';
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
      locations."/buy".return = "301 https://www.ikea.com/us/en/p/blahaj-soft-toy-shark-90373590/";
    };
    "files.inx.moe" = ssl-inx // {
      locations."/" = {
        root = "/srv/web/files.inx.moe";
        extraConfig = "autoindex on;";
      };
      locations."/p/" = {
        root = "/srv/web/files.inx.moe";
      };
    };
    "random.inx.moe" = ssl-inx // {
      locations."/" = {
        root = "/srv/web/files.inx.moe/subject";
        extraConfig = "random_index on;";
      };
    };
    "old.inx.moe" = ssl-inx-optional // {
      locations."/" = {
        root = "/srv/web/inx.moe/out";
        inherit tryFiles;
        extraConfig = websiteConfig;
      };
    };
    "tools.inx.moe" = ssl-inx // {
      locations."/" = {
        root = "${pkgs.it-tools}/share";
        tryFiles = "$uri $uri/ $uri.html /index.html";
      };
    };
  };

  services.uwsgi = {
    enable = true;
    plugins = [ "python3" ];
    instance.type = "emperor";
  };
}
