{ pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "23.05";

  info.loc.purdue = true;

  persist = {
    directories = [
    ];

    files = [
    ];
  };

  modules = {
    boot.grub.enable = true;
    hardware = {
      gpu.intel = true;
      form.laptop = true;

      peripherals = {
        fprint-sensor.enable = true;
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
    virtualization.enable = true;
  };

  programs.ns-usbloader.enable = true;

  services.fwupd = {
    enable = true;
    extraRemotes = [ "lvfs-testing" ];
    uefiCapsuleSettings.DisableCapsuleUpdateOnDisk = "true";
  };

  environment.variables = {
    GDK_DPI_SCALE = "1.25";
    QT_SCALE_FACTOR = "1.25";
  };

  services.autorandr.profiles =
    let
      eDP-1 = "00ffffffffffff0009e5ca0b000000002f200104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a0073";
      DP-4 = "00ffffffffffff0006b34116818202002b200104a52213783a28659759548e271e5054a10800b30095008180814081c0010101010101023a801871382d40582c450058c21000001e000000ff004e414c4d54463136343438310a000000fd00324b185311000a202020202020000000fc0041535553204d42313641430a20011802030a3165030c0010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003c";
      scale = { x = 0.8; y = 0.8; };
      config = {
        eDP-1 = { crtc = 0; mode = "2256x1504"; position = "1080x716"; primary = true; rate = "60.00"; inherit scale; };
        DP-4 = { crtc = 1; mode = "1920x1080"; position = "0x0"; rate = "60.00"; rotate = "left"; };
      };
    in
    {
      main = {
        fingerprint = {
          inherit eDP-1;
        };
        config = { inherit (config) eDP-1; };
      };
      portable-second = {
        fingerprint = {
          inherit eDP-1 DP-4;
        };
        config = {
          inherit (config) eDP-1 DP-4;
        };
      };
    };

  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";

  systemd.services.set-initial-backlight = {
    description = "Sets the initial backlight state on startup";
    wantedBy = [ "sys-devices-pci0000:00-0000:00:02.0-drm-card0-card0\\x2deDP\\x2d1-intel_backlight.device" ];
    after = [ "system-systemd\\x2dbacklight.slice" "systemd-backlight@backlight:intel_backlight.service" ];
    serviceConfig.Type = "oneshot";
    script = "${lib.getExe pkgs.acpilight} -set 50";
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
      system = "x86_64-linux";
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      protocol = "ssh-ng";
      maxJobs = 32;
      speedFactor = 16;
      sshUser = "remotebuild";
    }
  ];
}
