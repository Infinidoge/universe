{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "23.05";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG8fY684SPKeOUsJqaV6LJwwztWxztaU9nAHPBxBtyU root@Infini-OPTIPLEX";

  info.loc.purdue = true;

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
}
