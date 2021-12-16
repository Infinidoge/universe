{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.lists.flatten [
    (with suites; [ graphic ])

    (with profiles; [
      networking.wireless
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

      # /etc directories
      "/etc/ssh"

      # /var directories
      "/var/log"
      "/var/lib/fprint"
      "/var/lib/bluetooth"
      "/var/lib/systemd/coredump"
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
    };
    services = {
      proxy.enable = true;
    };
    filesystems = {
      enable = true;
      btrfs.enable = true;
    };
    desktop = {
      gaming = {
        steam.enable = true;
        multimc.enable = true;
      };
    };
    virtualization.enable = true;
  };

  networking.interfaces.wlp170s0.useDHCP = true;

  hardware.video.hidpi.enable = false;
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
  console.earlySetup = lib.mkDefault true;

  services.fprintd.enable = true;
}
