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
    ./hedgedoc.nix
    ./hydra.nix
    ./jellyfin.nix
    ./jupyter.nix
    ./postgresql.nix
    ./thelounge.nix
    ./vaultwarden.nix
    ./ssh.nix
  ];

  networking.hostId = "8fa7a57c";
  system.stateVersion = "23.11";

  info.loc.purdue = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  nix.distributedBuilds = false;

  modules = {
    hardware.form.server = true;
  };

  boot.loader.timeout = 5;

  virtualisation.enable = true;

  persist = {
    directories = [
      "/srv"
    ];
    files = [
    ];
  };

  nix.settings.accept-flake-config = true;

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
    failregex = ^<HOST>.*GET.*(\.php|admin|wp\-).* HTTP/\d.\d\" 404.*$
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

  systemd.services.setup-infiniband = {
    wantedBy = [ "network.target" ];
    script = ''
      echo "eth" > /sys/bus/pci/devices/0000:04:00.0/mlx4_port1
      echo "eth" > /sys/bus/pci/devices/0000:04:00.0/mlx4_port2
    '';
  };
}
