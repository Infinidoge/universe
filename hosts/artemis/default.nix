{
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

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF7PmPq/7e+YIVAvIcs6EOJ3pZVJhinwus6ZauJ3aVp0 root@artemis";

  info.loc.purdue = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.binfmt.addEmulatedSystemsToNixSandbox = true;

  home.home.packages = with pkgs; [
    ungoogled-chromium
    sidequest
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

  programs.alvr = {
    enable = true;
    openFirewall = true;
  };

  services.printing.enable = true;

  services.fwupd = {
    enable = true;
    extraRemotes = [ "lvfs-testing" ];
    uefiCapsuleSettings.DisableCapsuleUpdateOnDisk = "true";
  };
  systemd.services.fwupd-refresh = {
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
  };

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

  systemd.timers.systemd-hibernate = {
    enable = false;
    wantedBy = [ "multi-user.target" ];
    timerConfig.OnCalendar = "Mon..Fri,Sun *-*-* 00:30:00";
  };

  #networking.proxy.default = "http://infini-dl360.tailnet.inx.moe:8118";

  nix.gc.automatic = false; # Disable for NixCon

  services.xserver.wacom.enable = true;
  home.home.sessionVariables = {
    QT_XCB_TABLET_LEGACY_COORDINATES = "true";
  };
}
