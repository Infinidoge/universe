{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "23.05";

  info.loc.purdue = true;

  boot.loader.timeout = 1;

  modules = {
    hardware.form.desktop = true;
    hardware.gpu.intel = true;
    desktop.wm.enable = true;
  };


  persist = {
    directories = [
    ];

    files = [
    ];
  };
}
