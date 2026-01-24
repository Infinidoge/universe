{
  pkgs,
  lib,
  config,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/netboot/netboot.nix")
    (modulesPath + "/installer/scan/detected.nix")
    (modulesPath + "/installer/scan/not-detected.nix")

    ./latest-zfs-kernel.nix
    ./netboot.nix
    ./kexec
  ];

  system.stateVersion = config.system.nixos.release;

  modules.backups.enable = false;

  hardware.enableAllHardware = true;

  environment.systemPackages = with pkgs; [
    testdisk
    ms-sys
    efibootmgr
    efivar
    parted
    ddrescue
    ccrypt
    cryptsetup

    fuse
    fuse3
    sshfs-fuse
    socat
    tcpdump

    sdparm
    hdparm
    smartmontools
    pciutils
    usbutils
    nvme-cli

    unzip
    zip

    jq

    nixos-install-tools
    rsync
    disko
  ];

  boot.supportedFilesystems = lib.mkMerge [
    [
      "btrfs"
      "ntfs"
      "vfat"
    ]
    (lib.mkIf (lib.meta.availableOn pkgs.stdenv.hostPlatform config.boot.zfs.package) {
      zfs = lib.mkDefault true;
    })
    {
      bcachefs = lib.mkDefault true;
    }
  ];

  boot.zfs.package = pkgs.zfs_unstable;

  boot.initrd.systemd.emergencyAccess = true;

  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.max_pool_percent=50"
    "zswap.compressor=zstd"
    "zswap.zpool=zsmalloc"
  ];

  networking.hostId = lib.mkDefault "8425e349";

  services.openssh.settings.PermitRootLogin = lib.mkDefault "yes";

  boot.swraid.enable = true;
  boot.swraid.mdadmConf = "PROGRAM ${pkgs.coreutils}/bin/true";

  networking.firewall.logRefusedConnections = lib.mkDefault false;

  environment.etc."systemd/pstore.conf".text = ''
    [PStore]
    Unlink=no
  '';

  documentation = {
    enable = false;
    doc.enable = false;
    info.enable = false;
    man.enable = false;
    nixos.enable = false;
  };

  environment.stub-ld.enable = false;

  programs = {
    command-not-found.enable = false;
    fish.generateCompletions = false;
  };

  services = {
    logrotate.enable = false;
    udisks2.enable = false;
  };

  xdg = {
    autostart.enable = false;
    icons.enable = false;
    mime.enable = false;
    sounds.enable = false;
  };

  nix.settings = {
    connect-timeout = 5;
    extra-substituters = [ "/" ];
    log-lines = lib.mkDefault 25;
    max-free = lib.mkDefault (3000 * 1024 * 1024);
    min-free = lib.mkDefault (512 * 1024 * 1024);
    builders-use-substitutes = true;
  };

  # TODO: cargo culted to the second degree
  nix = {
    daemonCPUSchedPolicy = lib.mkDefault "batch";
    daemonIOSchedClass = lib.mkDefault "idle";
    daemonIOSchedPriority = lib.mkDefault 7;
  };

  networking.firewall.enable = false;
  networking.useNetworkd = true;
  systemd.network.enable = true;
}
