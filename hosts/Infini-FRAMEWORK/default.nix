{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
    ./displays.nix
  ];

  system.stateVersion = "23.05";

  info.loc.purdue = true;

  persist = {
    directories = [
      { directory = "/var/lib/dnsmasq/"; user = "dnsmasq"; }
    ];

    files = [
    ];
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  environment.enableDebugInfo = true;

  services.printing.drivers = [ pkgs.tmx-cups-ppd ];

  modules = {
    hardware = {
      gpu.intel = true;
      form.laptop = true;

      peripherals = {
        printing.enable = true;
      };
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

  services.fprintd.enable = true;
  virtualisation.enable = true;

  programs.ns-usbloader.enable = true;
  hardware.uinput.enable = true;
  services.joycond.enable = true;

  hardware.printers.ensurePrinters = [
    {
      name = "EPSON-TM-m30";
      deviceUri = "lpd://169.254.184.17/queue";
      model = "tm-m30-rastertotmt.ppd.gz";
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
    after = [ "system-systemd\\x2dbacklight.slice" "systemd-backlight@backlight:intel_backlight.service" ];
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
      systems = [ "x86_64-linux" "aarch64-linux" ];
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      protocol = "ssh-ng";
      maxJobs = 32;
      speedFactor = 16;
      sshUser = "remotebuild";
    }
  ];

  networking = {
    interfaces = {
      "wlp170s0".useDHCP = true;
      "enp0s13f0u1" = {
        ipv4.addresses = [{
          address = "192.168.100.1";
          prefixLength = 24;
        }];
      };
    };
    firewall.interfaces = {
      "enp0s13f0u1".allowedTCPPorts = [ 53 ];
      "enp0s13f0u1".allowedUDPPorts = [ 53 67 ];
    };

    nat = {
      enable = true;
      internalInterfaces = [ "enp0s13f0u1" ];
      externalInterface = "wlp170s0";
    };
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      server = [ "8.8.8.8" "1.1.1.1" ];
      domain-needed = true;
      bogus-priv = true;
      no-resolv = true;

      cache-size = 1000;

      dhcp-range = [ "enp0s13f0u1,192.168.100.10,192.168.100.100" ];
      interface = "enp0s13f0u1";
      dhcp-host = "192.168.100.1";

      local = "/lan/";
      domain = "lan";
      expand-hosts = true;

      no-hosts = true;
      address = "/infini-framework.lan/192.168.100.1";
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };
}
