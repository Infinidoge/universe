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
  services.copyparty = {
    enable = true;

    settings = {
      e2dsa = true;
      e2ts = true;
      ansi = true;
      re-maxage = 3600;

      shr = "/share";
      shr-adm = [ "infinidoge" ];

      # OAuth2
      idp-h-usr = "X-authentik-username";
      idp-h-key = private.variables.copyparty-key;
      xff-src = "lan";
      idp-adm = [ "infinidoge" ];
      idp-login = "https://files.inx.moe/oauth/authorize";
      idp-login-t = "Login with INX Central";
      auth-ord = "idp,pw,ipu";

      # BUG: These are not properly set in the copyparty module, as changing any settings removes them from default
      no-reload = true;
      hist = "/var/cache/copyparty";
    };

    volumes = {
      "/" = {
        path = "/srv/web/files.inx.moe";
        access = {
          rh = "*";
          A = [ "infinidoge" ];
        };
        flags = {
          chmod_f = "664";
          chmod_d = "775";
        };
      };
      "/p" = {
        path = "/srv/web/files.inx.moe/p";
        access = {
          h = "*";
          A = [ "infinidoge" ];
        };
        flags = {
          chmod_f = "664";
          chmod_d = "775";
        };
      };
    };
  };

  services.nginx.virtualHosts."files.inx.moe" = common.nginx.ssl-inx // {
    locations."/" = {
      proxyPass = "http://localhost:3923";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 0;

        auth_request /outpost.goauthentik.io/auth/nginx;
        auth_request_set $auth_cookie $upstream_http_set_cookie;
        add_header Set-Cookie $auth_cookie;

        auth_request_set $authentik_username $upstream_http_x_authentik_username;
        proxy_set_header X-authentik-username $authentik_username;
        proxy_set_header ${private.variables.copyparty-key} "OK";
      '';
    };
    locations."/outpost.goauthentik.io" = {
      proxyPass = "${authentik_internal}/outpost.goauthentik.io";
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
