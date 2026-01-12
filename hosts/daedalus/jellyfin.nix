{ config, common, ... }:
let
  address = "127.0.0.1";
  port = 8096;
  jellyfin = "http://${address}:${toString port}";
  proxyConfig = ''
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Protocol $scheme;
    proxy_set_header X-Forwarded-Host $http_host;
  '';
in
{
  services.nginx.virtualHosts."jellyfin.inx.moe" = common.nginx.ssl-inx // {
    extraConfig = ''
      client_max_body_size 20M;
    '';

    locations."= /" = {
      return = "302 https://$host/web/";
    };

    locations."/" = {
      proxyPass = jellyfin;
      recommendedProxySettings = false;
      extraConfig = proxyConfig + ''
        proxy_buffering off;
      '';
    };

    locations."= /web/" = {
      proxyPass = "${jellyfin}/web/index.html";
      recommendedProxySettings = false;
      extraConfig = proxyConfig;
    };

    locations."/socket" = {
      proxyPass = jellyfin;
      proxyWebsockets = true;
      recommendedProxySettings = false;
      extraConfig = proxyConfig;
    };
  };

  services.jellyfin = {
    enable = true;
    dataDir = "/srv/jellyfin";
    logDir = "/var/log/jellyfin";
    openFirewall = true;

    hardwareAcceleration = {
      enable = true;
      type = "qsv";
      device = "/dev/dri/renderD128";
    };

    transcoding = {
      enableHardwareEncoding = true;
      hardwareEncodingCodecs = {
        av1 = true;
        hevc = true;
      };
      hardwareDecodingCodecs = {
        av1 = true;
        h264 = true;
        hevc = true;
      };
    };
  };

  persist.directories = with config.services.jellyfin; [
    dataDir
    cacheDir
    logDir
  ];

  storage.directories = [
    "/srv/media"
  ];
}
