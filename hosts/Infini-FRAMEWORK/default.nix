{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
    ./displays.nix
    ./router.nix
  ];

  system.stateVersion = "23.05";

  info.loc.purdue = true;

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF7PmPq/7e+YIVAvIcs6EOJ3pZVJhinwus6ZauJ3aVp0 root@Infini-FRAMEWORK";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.binfmt.addEmulatedSystemsToNixSandbox = true;

  home.home.packages = with pkgs; [
    ungoogled-chromium
  ];

  environment.enableDebugInfo = true;

  modules = {
    hardware = {
      gpu.intel = true;
      form.laptop = true;
    };
    desktop = {
      wm.enable = true;
      gaming = {
        steam.enable = true;
        prismlauncher.enable = true;
        puzzles.enable = true;
      };
    };
  };

  universe.programming.all.enable = true;

  services.fprintd.enable = true;
  virtualisation.enable = true;

  programs.ns-usbloader.enable = true;
  hardware.uinput.enable = true;
  services.joycond.enable = true;

  programs.kdeconnect.enable = true;

  services.printing.enable = true;

  hardware.printers.ensurePrinters = [
    {
      name = "EPSON-TM-m30-remote";
      deviceUri = "ipp://100.101.102.18/printers/EPSON-TM-m30";
      model = "raw";
    }
  ];

  services.fwupd = {
    enable = true;
    extraRemotes = [ "lvfs-testing" ];
    uefiCapsuleSettings.DisableCapsuleUpdateOnDisk = "true";
  };
  systemd.services.fwupd-refresh.after = [ "network-online.target" ];
  systemd.services.fwupd-refresh.requires = [ "network-online.target" ];

  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";

  systemd.services.set-initial-backlight = {
    description = "Sets the initial backlight state on startup";
    wantedBy = [
      "sys-devices-pci0000:00-0000:00:02.0-drm-card0-card0\\x2deDP\\x2d1-intel_backlight.device"
      "sys-devices-pci0000:00-0000:00:02.0-drm-card1-card1\\x2deDP\\x2d1-intel_backlight.device"
    ];
    after = [
      "system-systemd\\x2dbacklight.slice"
      "systemd-backlight@backlight:intel_backlight.service"
    ];
    serviceConfig.Type = "oneshot";
    script = "${lib.getExe pkgs.brightnessctl} set 50%";
  };

  nix.buildMachines = [
    #{
    #  hostName = "infini-desktop";
    #  system = "x86_64-linux";
    #  supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    #  protocol = "ssh-ng";
    #  maxJobs = 16;
    #  speedFactor = 8;
    #  sshUser = "remotebuild";
    #}
    {
      hostName = "infini-dl360";
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      protocol = "ssh-ng";
      maxJobs = 32;
      speedFactor = 16;
      sshUser = "remotebuild";
    }
  ];

  networking.firewall.allowedUDPPorts = [ 51820 ];

  networking.wg-quick.interfaces.wg0 = {
    autostart = false;
    address = [ "10.10.0.3/32" ];
    listenPort = 51820;
    privateKeyFile = "/home/infinidoge/tmp/bb-vpn-geg.key";
    peers = [
      {
        publicKey = "SYpnrGvxx8l4w9c7KVRVW6GyNDr/iK+maPPMw/Ua7XY=";
        allowedIPs = [ "10.9.0.0/24" ];
        endpoint = "66.23.193.252:55555";
        persistentKeepalive = 25;
      }
    ];
  };
  networking.wg-quick.interfaces.wg1 = {
    autostart = false;
    address = [ "10.11.0.3/32" ];
    listenPort = 51820;
    privateKeyFile = "/home/infinidoge/tmp/bb-vpn-dfw.key";
    mtu = 1300;
    peers = [
      {
        publicKey = "uPejaHkvkjOAjm5s+ILbxmHnw2gh3A1Wtz++ijS5TmI=";
        allowedIPs = [ "10.40.1.0/24" ];
        endpoint = "104.167.215.168:51820";
        persistentKeepalive = 25;
      }
    ];
  };

  systemd.timers.systemd-hibernate = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    timerConfig.OnCalendar = "Mon..Fri,Sun *-*-* 00:30:00";
  };
}
