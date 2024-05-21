{ config, pkgs, lib, ... }:
let
  cfg = config.services.jitsi-meet;
in
{
  services.jitsi-meet = {
    enable = true;
    hostName = config.common.subdomain "meet";
    config = {
      prejoinPageEnabled = true;
      disableModeratorIndicator = true;
    };
    interfaceConfig = {
      SHOW_JITSI_WATERMARK = false;
    };
  };

  services.jitsi-videobridge.openFirewall = true;

  services.nginx.virtualHosts.${cfg.hostName} = {
    acmeRoot = null;
  };
}
