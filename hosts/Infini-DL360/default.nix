{
  lib,
  pkgs,
  private,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    ./secrets

    private.nixosModules.minecraft-servers
    ./authentik.nix
    ./conduwuit.nix
    ./factorio.nix
    ./forgejo.nix
    ./freshrss.nix
    ./hedgedoc.nix
    ./hydra.nix
    ./immich.nix
    ./jellyfin.nix
    ./jupyter.nix
    ./postgresql.nix
    ./privoxy.nix
    ./radicale.nix
    ./searx.nix
    ./ssh.nix
    ./thelounge.nix
    ./torrenting.nix
    ./vaultwarden.nix
    ./web.nix
  ];

  system.stateVersion = "23.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjmvE76BcPwZSjeNGzlguDQC67Yxa3uyOf5ZmVDWNys root@Infini-DL360";

  info.loc.purdue = true;

  networking.hostId = "8fa7a57c";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.binfmt.addEmulatedSystemsToNixSandbox = true;

  nix.distributedBuilds = false;

  modules.hardware.form.server = true;

  universe.programming.all.enable = true;

  boot.loader.timeout = 5;

  virtualisation.enable = true;

  persist.directories = [
    "/srv"
  ];

  nix.settings.accept-flake-config = true;

  networking = {
    firewall = {
      allowedUDPPorts = [
        80
        443
      ];
      allowedTCPPorts = [
        80
        443
        25565
      ];
    };

    bridges = {
      br0 = {
        interfaces = [
          "eno1"
          "eno2"
          "eno3"
          "eno4"
        ];
      };
    };
    interfaces.br0.ipv4.addresses = [
      {
        address = "192.168.137.11";
        prefixLength = 24;
      }
    ];
    dhcpcd.denyInterfaces = [ "eno*" ];

    defaultGateway = {
      address = "192.168.137.1";
      interface = "br0";
    };

    nat = {
      enable = true;
      internalInterfaces = [ "ve-*" ];
      externalInterface = "br0";
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  hardware.infiniband.enable = true;

  services.fail2ban.enable = true;

  environment.etc."fail2ban/filter.d/nginx-url-probe.local".text = lib.mkDefault (
    lib.mkAfter ''
      [Definition]
      failregex = ^<HOST>.*GET.*(\.php|admin|wp\-).* HTTP/\d.\d\" 404.*$
    ''
  );

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
    extraDomainNames = [
      "*.inx.moe"
      "*.internal.inx.moe"
      "*.tailnet.inx.moe"
    ];
  };

  services.nginx.virtualHosts."*.inx.moe" = {
    useACMEHost = "inx.moe";
    addSSL = true;
    default = true;
    globalRedirect = "inx.moe";
    redirectCode = 302;
  };

  services.borgbackup.jobs."persist" =
    let
      tmux = lib.getExe pkgs.tmux;
    in
    {
      preHook = ''
        for sock in /run/minecraft/*.sock; do
          ${tmux} -S $sock send-keys "say Server is backing up..." Enter
          ${tmux} -S $sock send-keys save-off Enter
          ${tmux} -S $sock send-keys save-all Enter
        done
      '';
      postHook = ''
        for sock in /run/minecraft/*.sock; do
          ${tmux} -S $sock send-keys save-on Enter
          ${tmux} -S $sock send-keys "say Backup complete" Enter
        done
      '';
    };

  systemd.services.setup-infiniband = {
    wantedBy = [ "network.target" ];
    script = ''
      echo "eth" > /sys/bus/pci/devices/0000:04:00.0/mlx4_port1
      echo "eth" > /sys/bus/pci/devices/0000:04:00.0/mlx4_port2
    '';
    serviceConfig = {
      User = "root";
      Group = "root";
    };
  };

  environment.systemPackages = with pkgs; [
    ffmpeg-full
    imagemagick
  ];
}
