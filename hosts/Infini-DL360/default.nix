{ config, lib, pkgs, private, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix

    ./web.nix

    private.nixosModules.minecraft-servers
    ./conduwuit.nix
    ./factorio.nix
    ./forgejo.nix
    ./freshrss.nix
    ./hydra.nix
    ./jellyfin.nix
    ./jitsi.nix
    ./postgresql.nix
    ./thelounge.nix
    ./vaultwarden.nix
  ];

  networking.hostId = "8fa7a57c";
  system.stateVersion = "23.11";

  info.loc.purdue = true;

  nix.distributedBuilds = false;

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

  documentation.man.man-db.enable = false;

  networking = {
    firewall = {
      allowedUDPPorts = [ 80 443 ];
      allowedTCPPorts = [ 80 443 25565 ];
    };
  };

  hardware.infiniband = {
    enable = true;
  };

  services.fail2ban.enable = true;

  environment.etc."fail2ban/filter.d/nginx-url-probe.local".text = lib.mkDefault (lib.mkAfter ''
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

  modules.backups.excludes = {
    "/var/log/" = [
      "nginx/access.log"
    ];
  };

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

  services.minecraft-servers.servers.emd-server.autoStart = lib.mkForce false;

  services.borgbackup.jobs."persist" = let tmux = lib.getExe pkgs.tmux; in {
    preHook = ''
      ${tmux} -S /run/minecraft/friend-server.sock send-keys "say Server is backing up..." Enter
      ${tmux} -S /run/minecraft/friend-server.sock send-keys save-off Enter
      ${tmux} -S /run/minecraft/friend-server.sock send-keys save-all Enter
      ${tmux} -S /run/minecraft/sister-server.sock send-keys "say Server is backing up..." Enter
      ${tmux} -S /run/minecraft/sister-server.sock send-keys save-off Enter
      ${tmux} -S /run/minecraft/sister-server.sock send-keys save-all Enter
    '';
    postHook = ''
      ${tmux} -S /run/minecraft/friend-server.sock send-keys save-on Enter
      ${tmux} -S /run/minecraft/friend-server.sock send-keys "say Backup complete" Enter
      ${tmux} -S /run/minecraft/sister-server.sock send-keys save-on Enter
      ${tmux} -S /run/minecraft/sister-server.sock send-keys "say Backup complete" Enter
    '';
  };
}
