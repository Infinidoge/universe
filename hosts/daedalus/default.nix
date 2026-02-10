{
  lib,
  pkgs,
  private,
  nixos,
  ...
}:
{
  imports = with nixos; [
    base
    backups
    borg
    common
    email
    extra
    grub
    home-manager
    kmscon
    locale
    man
    networking
    nginx
    nix
    options
    persist
    rsyncnet
    secrets
    ssh
    state-version
    tailscale
    virtualisation
    filesystems.btrfs
    filesystems.encrypted
    filesystems.zfs
    hardware.gpu.intel
    locations.purdue
    shells.xonsh
    shells.zsh

    ./hardware-configuration.nix
    ./disks.nix
    ./secrets

    private.nixosModules.minecraft-servers
    private.nixosModules.wireguard
    ./authentik.nix
    ./continuwuity.nix
    ./copyparty.nix
    ./drasl.nix
    ./factorio.nix
    ./forgejo.nix
    ./freshrss.nix
    ./garage.nix
    ./grafana.nix
    ./hedgedoc.nix
    ./homebox.nix
    ./hydra.nix
    ./immich.nix
    ./jellyfin.nix
    ./jupyter.nix
    ./minecraft.nix
    ./murmur.nix
    ./pds.nix
    ./postgresql.nix
    ./privoxy.nix
    ./radicale.nix
    ./searx.nix
    ./ssh.nix
    ./thelounge.nix
    ./torrenting.nix
    ./users.nix
    ./vaultwarden.nix
    ./web.nix
    ./weblate.nix
    ./wireguard.nix
  ];

  system.stateVersion = "23.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjmvE76BcPwZSjeNGzlguDQC67Yxa3uyOf5ZmVDWNys root@daedalus";

  # TODO: Force-import ZFS with hashed hostname hostId
  networking.hostId = lib.mkForce "8fa7a57c";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.binfmt.addEmulatedSystemsToNixSandbox = true;

  nix.distributedBuilds = false;

  boot.loader.timeout = 5;

  persist.directories = [
    "/srv"
  ];

  nix.settings.accept-flake-config = true;
  nix.gc.automatic = false;

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
        55555
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
  services.fail2ban = {
    bantime = "1h";
    bantime-increment = {
      enable = true;
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };
  };

  services.fail2ban.jails.nginx-url-probe = {
    enabled = true;
    filter = {
      Definition = {
        failregex = ''^<HOST>.*GET.*(\.php|admin|wp\-).* HTTP/\d.\d\" 404.*$'';
      };
    };
    settings = {
      logpath = "/var/log/nginx/access.log";
      port = "80,443";
      backend = "auto";
      maxretry = 5;
      findtime = 600;
    };
  };

  services.nginx.enable = true;

  backups.persist.excludes = {
    "/var/log/" = [
      "nginx/access.log"
    ];

    # Very large fungible files
    "/srv/media/" = [
      "shows/Dimension 20 Fantasy High"
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
          ${tmux} -S $sock send-keys "say Server is backing up..." Enter && \
            ${tmux} -S $sock send-keys save-off Enter && \
            ${tmux} -S $sock send-keys save-all Enter || \
            echo "$sock failed to execute save"
        done
      '';
      postHook = ''
        for sock in /run/minecraft/*.sock; do
          ${tmux} -S $sock send-keys save-on Enter && \
            ${tmux} -S $sock send-keys "say Backup complete" Enter || \
            echo "$sock failed to reenable saving"
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

  services.printing.enable = true;

  boot.supportedFilesystems.nfs = true;
}
