{ nixos, ... }:
{
  imports = with nixos; [
    base
    backups
    borg
    email
    graphical
    grub
    home-manager
    kmscon
    locale
    man
    networking
    nix
    node
    options
    persist
    qtile
    rsyncnet
    secrets
    ssh
    state-version
    tailscale
    filesystems.btrfs
    filesystems.encrypted
    hardware.audio
    hardware.gpu.intel
    hardware.receipt-printer
    hardware.wifi
    locations.purdue

    ./hardware-configuration.nix
    ./disks.nix
  ];

  system.stateVersion = "26.05";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAKvGPh6rPAkfIcXOBGGWMiChCVfbsstJBKeRJuAIopY root@bacchus";

  info.model = "OptiPlex 5040";

  services.printing = {
    enable = true;
    listenAddresses = [
      "localhost:631"
      "100.101.102.151:631"
      "bacchus.tailnet.inx.moe:631"
    ];
    allowFrom = [ "all" ];
    defaultShared = true;
    openFirewall = true;
  };
}
