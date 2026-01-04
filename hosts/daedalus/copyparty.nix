{
  common,
  config,
  private,
  ...
}:
let
  authentik_internal = config.services.nginx.virtualHosts."auth.inx.moe".locations."/".proxyPass;
in
{
  persist.directories = [
    "/var/lib/copyparty"
    "/var/cache/copyparty"
  ];

  services.copyparty = {
    enable = true;

    settings = {
      e2dsa = true;
      e2ts = true;
      ansi = true;
      stats = true;
      no-robots = true;
      re-maxage = 3600;
      df = "30";

      chmod-f = "664";
      chmod-d = "775";

      shr = "/share";
      shr-adm = [ "infinidoge" ];

      xff-src = "lan";
      xff-hdr = "x-forwarded-for";
      rproxy = 1;

      # OAuth2
      idp-h-usr = "X-authentik-username";
      idp-h-key = private.variables.copyparty-key;
      idp-adm = [ "infinidoge" ];
      idp-login = "https://files.inx.moe/oauth/authorize";
      idp-login-t = "Login with INX Central";
      auth-ord = "pw,idp,ipu";

      no-reload = true;
      hist = "/var/cache/copyparty";
    };

    globalExtraConfig = ''
      # imperatively managed file for extra users and their directories
      c: /var/lib/copyparty/users.conf
    '';

    volumes = {
      "/" = {
        path = "/srv/files";
        access = {
          rh = "*";
          A = [ "infinidoge" ];
        };
      };
      "/p" = {
        path = "/srv/files/p";
        access = {
          h = "*";
          A = [ "infinidoge" ];
        };
      };
      "/p/media" = {
        path = "/srv/media";
        access = {
          A = [ "infinidoge" ];
        };
        flags = {
          gid = 994; # jellyfin
        };
      };
      "/usr" = {
        path = "/srv/files/usr";
        access = {
          rh = "*";
          A = [ "infinidoge" ];
        };
      };
    };
  };

  users.users.copyparty.extraGroups = [
    "jellyfin"
  ];

  services.nginx.virtualHosts."files.inx.moe" = common.nginx.ssl-inx // {
    extraConfig = ''
      proxy_busy_buffers_size 512k;
      proxy_buffers 4 512k;
      proxy_buffer_size 256k;
    '';
    locations."/" = {
      proxyPass = "http://localhost:3923";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 0;
        proxy_buffering off;
        proxy_request_buffering off;
        proxy_buffers 32 8k;
        proxy_buffer_size 16k;
        proxy_busy_buffers_size 24k;

        auth_request /outpost.goauthentik.io/auth/nginx;
        auth_request_set $auth_cookie $upstream_http_set_cookie;
        add_header Set-Cookie $auth_cookie;

        auth_request_set $authentik_username $upstream_http_x_authentik_username;
        proxy_set_header X-authentik-username $authentik_username;
        proxy_set_header ${private.variables.copyparty-key} "OK";
      '';
    };
    locations."/outpost.goauthentik.io" = {
      #proxyPass = "${authentik_internal}/outpost.goauthentik.io";
      proxyPass = "http://127.0.0.1:9000/outpost.goauthentik.io";
      extraConfig = ''
        client_max_body_size 0;

        proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
        add_header Set-Cookie $auth_cookie;
        auth_request_set $auth_cookie $upstream_http_set_cookie;
        proxy_pass_request_body off;
        proxy_set_header Content-Length "";
      '';
    };
    locations."/oauth/authorize" = {
      extraConfig = ''
        add_header Set-Cookie $auth_cookie;
        return 302 /outpost.goauthentik.io/start?rd=/;
      '';
    };
  };
}
