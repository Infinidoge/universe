{ config, pkgs, lib, inputs, ... }: {
  imports = [ inputs.nixos-hardware.outputs.nixosModules.raspberry-pi-4 ];

  boot = {
    tmpOnTmpfs = true;
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
    ];

    loader = {
      raspberryPi = {
        enable = true;
        version = 4;
      };

      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  hardware.raspberry-pi."4" = {
    fkms-3d.enable = true;
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  environment.systemPackages = with pkgs; [
    raspberrypi-eeprom
  ];
}
