{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix

    ./web.nix

    ./factorio.nix
    ./forgejo.nix
    ./freshrss.nix
    ./jellyfin.nix
    ./thelounge.nix
    ./vaultwarden.nix
  ];

  networking.hostId = "8fa7a57c";
  system.stateVersion = "23.11";

  info.loc.purdue = true;

  modules = {
    boot.grub.enable = true;
    boot.timeout = 5;
    hardware.form.server = true;
  };

  persist = {
    directories = [
      "/srv"

      # TODO: Setup in module
      "/var/lib/acme"
    ];
    files = [
    ];
  };

  networking = {
    firewall = {
      allowedUDPPorts = [ 80 443 ];
      allowedTCPPorts = [ 80 443 ];
    };
  };

  services.fail2ban.enable = true;

  environment.etc."fail2ban/filter.d/nginx-url-probe.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
      [Definition]
      failregex = ^<HOST>.*(GET /(wp-|admin|boaform|phpmyadmin|\.env|\.git|notifications)|\.(dll|so|cfm|asp)|(\?|&)(=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000|=PHPE9568F36-D428-11d2-A769-00AA001ACF42|=PHPE9568F35-D428-11d2-A769-00AA001ACF42|=PHPE9568F34-D428-11d2-A769-00AA001ACF42)|\\x[0-9a-zA-Z]{2})
  '');

  services.fail2ban.jails.nginx-url-probe.settings = {
    enabled = true;
    filter = "nginx-url-probe";
    logpath = "/var/log/nginx/access.log";
    action = "%(action_)s[blocktype=DROP]";
    backend = "auto";
    maxretry = 5;
    findtime = 600;
  };

  services.nginx.enable = true;

  security.acme.certs."inx.moe" = {
    group = "nginx";
    extraDomainNames = [ "*.inx.moe" ];
  };

  services.nginx.virtualHosts."*.inx.moe" = {
    useACMEHost = "inx.moe";
    addSSL = true;
    default = true;
    globalRedirect = "inx.moe";
    redirectCode = 302;
  };
}
