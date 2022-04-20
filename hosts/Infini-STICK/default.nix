{ lib, suites, profiles, ... }: {
  imports = lib.lists.flatten [
    (with suites; [ base develop ])

    (with profiles; [
      networking.wireless
    ])

    ./hardware-configuration.nix
  ];

  networking.interfaces.wlp170s0.useDHCP = true;
  # networking.interfaces.enp39s0.useDHCP = true;

  modules = {
    boot.grub.enable = true;
    hardware = {
      audio.enable = true;
      form.portable = true;
    };
    services.proxy.enable = false;
  };

  environment.persistence."/persist" = {
    directories = [
      "/home"
      "/etc/nixos"

      # /var directories
      "/var/log"
      "/var/lib/systemd/coredump"
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

  system.stateVersion = "21.11";
}
