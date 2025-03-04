{
  common,
  config,
  secrets,
  ...
}:
let
  domain = common.subdomain "graph";
  secret = secret: "$__file{/etc/secrets/grafana/${secret}}";
in
{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        inherit domain;
      };
      security = {
        admin_email = common.email.withUser "admin";
        cookie_secure = true;
        secret_key = secret "secret_key";
      };
      auth = {
        signout_redirect_url = "https://auth.inx.moe/application/o/grafana/end-session";
        auto_login = "authentik";
      };
      "auth.anonymous".enabled = true;
      "auth.basic".enabled = false;
      "auth.generic_oauth" = {
        name = "authentik";
        enabled = true;
        client_id = "yL4qqsKyc5i9mhvVUNFHcQyTGaYWxnqtMvceg0kY";
        client_secret = secret "client_secret";
        scopes = "openid email profile";
        auth_url = "https://auth.inx.moe/application/o/authorize/";
        token_url = "https://auth.inx.moe/application/o/token/";
        api_url = "https://auth.inx.moe/application/o/userinfo/";
        role_attribute_path = "contains(groups, 'Grafana Admins') && 'Admin' || contains(groups, 'Grafana Editors') && 'Editor' || 'Viewer'";
      };
      smtp = with common.email; {
        user = outgoing;
        from_address = withSubaddress "grafana";
        from_name = "Grafana";
        key_file = secrets.smtp-noreply;
        startTLS_policy = "MandatoryStartTLS";
        host = "${smtp.address}:${toString smtp.STARTTLS}";
      };
      users = {
        allow_org_create = true;
        hidden_users = "admin";
      };
    };
  };

  services.nginx.virtualHosts.${domain} = common.nginx.ssl-inx // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
    };
  };
}
