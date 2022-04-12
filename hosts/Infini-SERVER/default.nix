{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.flatten [
    (with suites; [ base ])

    ./hardware-configuration.nix
  ];

  modules = {
    boot = {
      grub.enable = true;
      timeout = 1;
    };
    hardware = {
      # gpu.nvidia = true;
      form.server = true;
    };
    filesystems = {
      enable = true;
      btrfs.enable = true;
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

      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"

      "/root/.local/share/nix/trusted-settings.json"
      "/root/.ssh/known_hosts"
    ];
  };
}
