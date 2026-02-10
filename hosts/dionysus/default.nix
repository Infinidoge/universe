{ nixos, ... }:
{
  imports = with nixos; [
    base
    backups
    borg
    common
    email
    extra
    graphical
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
    qtile
    rsyncnet
    secrets
    ssh
    state-version
    tailscale
    filesystems.btrfs
    hardware.audio
    hardware.gpu.intel
    hardware.receipt-printer
    locations.purdue
    shells.xonsh
    shells.zsh

    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "23.05";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG8fY684SPKeOUsJqaV6LJwwztWxztaU9nAHPBxBtyU root@dionysus";

  boot.loader.timeout = 1;

  services.printing = {
    enable = true;
    listenAddresses = [
      "localhost:631"
      "100.101.102.18:631"
      "dionysus:631"
    ];
    allowFrom = [ "all" ];
    defaultShared = true;
    openFirewall = true;
  };

  services.httpd = {
    enable = true;
    virtualHosts."dionysus.tailnet.inx.moe" = rec {
      documentRoot = "/srv/seppo";
      extraConfig = ''
        AddHandler cgi-script .cgi

        <Directory "${documentRoot}">
            AllowOverride All
            Options All
            Require all granted
        </Directory>
      '';
    };
  };
}
