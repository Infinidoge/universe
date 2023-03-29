{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.lists.flatten [
    (with suites; [ base ])

    (with profiles; [
      networking.wireless
      # services.proxy
    ])

    ./hardware-configuration.nix
  ];

  system.stateVersion = "21.11";

  environment.persistence."/persist" = {
    directories = [
      "/home"
      "/etc/nixos"

      "/root/.local/share/nix"
      "/root/.ssh"

      # /var directories
      "/var/log"
      "/var/lib/fprint"
      "/var/lib/bluetooth"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/backlight"
      "/var/lib/tailscale"
      "/var/lib/alsa"
      "/var/lib/libvirt"
    ];

    files = [
      "/etc/machine-id"
    ];
  };

  modules = {
    boot.grub.enable = true;
    hardware = {
      gpu.intel = true;
      form.laptop = true;

      peripherals = {
        fprint-sensor.enable = true;
      };
    };
    desktop = {
      wm.enable = true;
      gaming = {
        steam.enable = true;
        prismlauncher.enable = true;
      };
    };
    virtualization.enable = true;
  };

  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";

  systemd.services.set-initial-backlight = {
    description = "Sets the initial backlight state on startup";
    wantedBy = [ "sys-devices-pci0000:00-0000:00:02.0-drm-card0-card0\\x2deDP\\x2d1-intel_backlight.device" ];
    after = [ "system-systemd\\x2dbacklight.slice" "systemd-backlight@backlight:intel_backlight.service" ];
    serviceConfig.Type = "oneshot";
    script = "${lib.getExe pkgs.acpilight} -set 50";
  };
}
