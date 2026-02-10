{
  config,
  pkgs,
  lib,
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
    graphical
    grub
    home-manager
    kmscon
    locale
    man
    networking
    nix
    options
    persist
    qtile
    rsyncnet
    secrets
    ssh
    state-version
    tailscale
    virtualisation
    filesystems.btrfs
    filesystems.encrypted
    filesystems.windows
    hardware.audio
    hardware.bluetooth
    hardware.fingerprint
    hardware.receipt-printer
    hardware.wifi
    hardware.yubikey
    hardware.gpu.nvidia
    programs.android
    programs.games
    programs.media
    programs.obs
    shells.xonsh
    shells.zsh

    ./hardware-configuration.nix
    ./filesystems.nix
    ./privoxy.nix
  ];

  system.stateVersion = "21.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7uX1myj9ghv7wMoL038oGDCdScdyLd7RvYdnoioSBh root@apophis";

  persist.directories = [
    "/srv"
  ];

  backups.persist.extraExcludes = [
    "/home/infinidoge/Hydrus"
  ];

  services.printing.enable = true;

  home.home.packages = with pkgs; [
    arduino
    hydrus
    razergenie # TODO: replace with polychromatic

    sidequest
    unityhub
    vrc-get
    blender
  ];

  programs.ns-usbloader.enable = true;
  programs.minipro.enable = false; # FIX: minipro build failure

  hardware.openrazer = {
    enable = false; # https://github.com/NixOS/nixpkgs/issues/393664
    users = [ config.user.name ];
  };

  services.minecraft-servers = {
    enable = true;

    servers = { };
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];

  services.openssh.extraConfig = lib.mkBefore ''
    XAuthLocation ${pkgs.xorg.xauth}/bin/xauth

    Match user infinidoge
      X11Forwarding yes
      X11UseLocalhost no
  '';

  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  services.xserver.wacom.enable = true;
  home.home.sessionVariables = {
    QT_XCB_TABLET_LEGACY_COORDINATES = "true";
  };

  services.apcupsd = {
    enable = true;
    configText = ''
      UPSNAME UPS
      UPSCLASS standalone
      UPSMODE disable
      NETSERVER on
      NISPORT 3551

      BATTERYLEVEL 35
      MINUTES 5

      UPSTYPE usb
      UPSCABLE usb
      NISIP 0.0.0.0
    '';

    # Other device config:
    # UPSCABLE ether
    # UPSTYPE net
    # DEVICE ipaddress:3551
    # POLLTIME 10
  };
  networking.firewall.allowedTCPPorts = [ 3551 ];
}
