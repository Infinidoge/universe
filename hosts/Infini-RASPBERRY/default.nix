{ inputs, config, lib, pkgs, ... }:
with lib;
{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    inputs.nixos-generators.nixosModules.sd-aarch64
  ];

  system.stateVersion = "23.11";
  modules = {
    hardware.form.raspi = true;
  };

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  nixpkgs.hostPlatform.system = "aarch64-linux";

  modules.hardware = {
    wireless.enable = mkDefault true;
  };

  boot = {
    kernelPackages = mkForce pkgs.linuxPackages_rpi4;

    # Removes ZFS >:(
    supportedFilesystems = mkForce [ "btrfs" "cifs" "f2fs" "jfs" "ntfs" "reiserfs" "vfat" "xfs" "ext4" "vfat" ];

    tmp.useTmpfs = true;
    # kernelParams = [
    #   "8250.nr_uarts=1"
    #   "console=ttyAMA0,115200"
    #   "console=tty1"
    # ];

    loader = {
      grub.enable = mkForce false;
      generic-extlinux-compatible.enable = mkForce true;
    };
  };

  hardware.deviceTree = {
    enable = true;
    # filter = "*rpi-4-*.dtb";
  };

  hardware.raspberry-pi."4" = {
    fkms-3d.enable = true;
    apply-overlays-dtmerge.enable = true;
    audio.enable = config.modules.hardware.audio.enable;
  };

  powerManagement.cpuFreqGovernor = mkDefault "ondemand";

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  users.groups.gpio = { };
  services.udev.extraRules = ''
    SUBSYSTEM=="bcm2835-gpiomem", KERNEL=="gpiomem", GROUP="gpio",MODE="0660"
    SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio  /sys/class/gpio/export /sys/class/gpio/unexport ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
    SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add",RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value ; chmod 660 /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value'"
  '';
}
