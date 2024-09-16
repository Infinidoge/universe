{ config, pkgs, lib, ... }: {
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

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  environment.enableDebugInfo = true;

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
      fingerprints = {
        framework = "00ffffffffffff0009e5ca0b000000002f200104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a0073";
        portable-second = "00ffffffffffff0006b34116818202002b200104a52213783a28659759548e271e5054a10800b30095008180814081c0010101010101023a801871382d40582c450058c21000001e000000ff004e414c4d54463136343438310a000000fd00324b185311000a202020202020000000fc0041535553204d42313641430a20011802030a3165030c0010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003c";
        dock = "00ffffffffffff0010ac0c40384c41421e0f01030e261f78ee1145a45a4aa024145054a54b00714f8180010101010101010101010101302a009851002a4030701300782d1100001e000000ff00543631313635374d42414c380a000000fc0044454c4c203139303546500a20000000fd00384c1e510e000a2020202020200083";
        dorm = "00ffffffffffff0010ac27f1493431442a1f010380301b78eab675a655529f270f5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c4500dc0c1100001e000000ff00484b50474c4a330a2020202020000000fc0044454c4c204532323231484e0a000000fd00384c1e5311000a2020202020200105020317b14c901f0102030712160413140565030c001000023a801871382d40582c4500dc0c1100001e011d8018711c1620582c2500dc0c1100009e011d007251d01e206e285500dc0c1100001e8c0ad08a20e02d10103e9600dc0c110000180000000000000000000000000000000000000000000000000000000000000000b9";
      };
      scale = { x = 0.8; y = 0.8; };
      config = lib.mapAttrs (n: v: v // { fingerprint = fingerprints.${n}; }) {
        framework = { mode = "2256x1504"; primary = true; inherit scale; };
        portable-second = { mode = "1920x1080"; rotate = "left"; };
        dock = { mode = "1280x1024"; };
        dorm = { mode = "1920x1080"; };
      };
      mkConfig = config: {
        fingerprint = lib.mapAttrs (_: v: v.fingerprint) config;
        config = lib.mapAttrs (_: v: lib.removeAttrs v [ "fingerprint" ]) config;
      };
    in
    lib.mapAttrs (_: mkConfig) (with config; {
      main = {
        eDP-1 = framework // { position = "0x0"; };
      };
      portable-second = {
        eDP-1 = framework // { position = "1080x716"; };
        DP-4 = portable-second // { position = "0x0"; };
      };
      docked = {
        eDP-1 = framework // { position = "1080x716"; };
        DP-1-3 = dock // { position = "2885x506"; };
      };
      docked-alt = {
        eDP-1 = framework // { position = "1080x716"; };
        DP-4 = portable-second // { position = "0x0"; };
        DP-1-3 = dock // { position = "2885x506"; };
      };
      dorm = {
        eDP-1 = framework // { position = "1920x0"; };
        DP-4 = dorm // { position = "0x0"; };
      };
    });

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
}
