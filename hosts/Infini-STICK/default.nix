{ lib, suites, profiles, private, ... }: {
  imports = lib.lists.flatten [
    (with suites; [ base develop ])

    private.nixosModules.wireless

    ./hardware-configuration.nix
  ];

  modules = {
    boot.grub.enable = true;
    hardware = {
      audio.enable = true;
      form.portable = true;
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/home"
      "/etc/nixos"

      # /var directories
      "/var/log"
      "/var/lib/systemd/coredump"
      "/var/lib/tailscale"
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
