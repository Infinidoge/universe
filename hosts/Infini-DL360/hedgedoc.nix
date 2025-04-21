{
  config,
  common,
  secrets,
  ...
}:
let
  cfg = config.services.hedgedoc;
  domain = common.subdomain "md";
in
{
  services.hedgedoc = {
    enable = true;
    environmentFile = secrets."hedgedoc";
    settings = {
      inherit domain;
      protocolUseSSL = true;
      port = 4003;

      db = {
        dialect = "sqlite";
        storage = "/srv/hedgedoc/db.sqlite";
      };
      uploadsPath = "/srv/hedgedoc/uploads";

      allowFreeURL = true;
      requireFreeURLAuthentication = true;

      oauth2 = {
        baseURL = "https://auth.inx.moe";
        userProfileURL = "https://auth.inx.moe/application/o/userinfo/";
        userProfileUsernameAttr = "preferred_username";
        userProfileDisplayNameAttr = "name";
        userProfileEmailAttr = "email";
        tokenURL = "https://auth.inx.moe/application/o/token/";
        authorizationURL = "https://auth.inx.moe/application/o/authorize/";
        clientID = "W1nhnUi43GweNljV4ADGfZ9VKuH4aoN1cwCUNlFp";
        scope = "openid email profile";
      };
    };
  };

  services.nginx.virtualHosts.${domain} = common.nginx.ssl-inx // {
    locations."/" = {
      proxyPass = "http://${cfg.settings.host}:${toString cfg.settings.port}";
      proxyWebsockets = true;
    };
  };

  systemd.services.hedgedoc.serviceConfig = {
    ReadWritePaths = [ "-/srv/hedgedoc" ];
    SystemCallFilter = [ "@chown" ];
  };
}
