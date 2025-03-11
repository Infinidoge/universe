{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "23.05";

  info.loc.purdue = true;

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG8fY684SPKeOUsJqaV6LJwwztWxztaU9nAHPBxBtyU root@Infini-OPTIPLEX";

  boot.loader.timeout = 1;

  modules = {
    hardware.form.desktop = true;
    hardware.gpu.intel = true;
    desktop.wm.enable = true;
  };

  services.printing = {
    enable = true;
    listenAddresses = [
      "localhost:631"
      "100.101.102.18:631"
      "infini-optiplex:631"
    ];
    allowFrom = [ "all" ];
    defaultShared = true;
    openFirewall = true;
  };

  nix.buildMachines = [
    {
      hostName = "infini-dl360";
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      protocol = "ssh-ng";
      maxJobs = 32;
      speedFactor = 16;
      sshUser = "remotebuild";
    }
  ];

  persist = {
    directories = [
    ];

    files = [
    ];
  };
}
