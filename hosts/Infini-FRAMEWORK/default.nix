{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.lists.flatten [
    (with suites; [ graphic ])

    (with profiles; [
      boot.grub

      networking.wireless

      (with hardware; [
        sound
        laptop
        gpu.intel
      ])

      services.privoxy
    ])

    ./hardware-configuration.nix
  ];

  system.stateVersion = "21.11";

  environment.persistence."/persist" = {
    directories = [
      "/home"
      "/etc/nixos"
      "/var/log"
      # "/var/lib/bluetooth"
      # "/var/lib/systemd/coredump"
    ];

    files = [
      "/etc/machine-id"
    ];
  };

  networking.interfaces.wlp170s0.useDHCP = true;

  hardware.video.hidpi.enable = false;
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
  console.earlySetup = lib.mkDefault true;

  services.fprintd.enable = true;
}
