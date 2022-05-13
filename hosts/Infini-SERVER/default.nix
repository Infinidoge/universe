{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.flatten [
    (with suites; [ base ])

    ./hardware-configuration.nix
  ];

  system.stateVersion = "22.05";

  modules = {
    boot = {
      grub.enable = true;
      timeout = 1;
    };
    hardware = {
      # gpu.nvidia = true;
      form.server = true;
    };
  };

  services = {
    avahi.reflector = true;

    soft-serve.enable = true;
  };

  networking.interfaces = {
    enp0s25.useDHCP = true;
  };

  environment.persistence."/persist" = {
    directories = [
      "/home"
      "/etc/nixos"

      # /var directories
      "/var/log"
      "/var/lib/systemd/coredump"

      "/srv"
    ];

    files = [
      "/etc/machine-id"

      "/root/.local/share/nix/trusted-settings.json"
      "/root/.ssh/known_hosts"
      "/root/.ssh/id_25519"
      "/root/.ssh/id_25519.pub"
      "/root/.ssh/immutable_files.txt"
    ];
  };
}
