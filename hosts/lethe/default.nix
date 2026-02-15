{
  pkgs,
  lib,
  config,
  modulesPath,
  nixos,
  inputs,
  ...
}:
{
  imports = with nixos; [
    base
    common
    home-manager
    kmscon
    locale
    networking
    nix
    options
    ssh
    state-version
    # tailscale # TODO: ephemeral tailscale setup
    filesystems.btrfs
    filesystems.encrypted
    filesystems.windows
    filesystems.zfs
    shells.xonsh
    shells.zsh

    (modulesPath + "/installer/netboot/netboot.nix")
    (modulesPath + "/installer/scan/detected.nix")
    (modulesPath + "/installer/scan/not-detected.nix")

    ./netboot.nix
    ./kexec
  ];

  system.stateVersion = config.system.nixos.release;

  boot.initrd.systemd = {
    enable = true;
  };

  nix.registry = lib.mkForce {
    nixpkgs.flake = inputs.nixpkgs;
  };

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

  services.kmscon.autologinUser = "infinidoge";

  boot.initrd.systemd.emergencyAccess = true;

  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.max_pool_percent=50"
    "zswap.compressor=zstd"
    "zswap.zpool=zsmalloc"
  ];

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
