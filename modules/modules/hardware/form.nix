{ config, lib, pkgs, inputs, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.modules.hardware.form;
in
{
  options.modules.hardware.form = with types; {
    desktop = mkBoolOpt false;
    laptop = mkBoolOpt false;
    portable = mkBoolOpt false;
    raspi = mkBoolOpt false;
    server = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.desktop {
      modules.hardware.audio.enable = mkDefault true;
    })
    (mkIf cfg.laptop {
      modules.hardware = {
        wireless.enable = mkDefault true;
        audio.enable = mkDefault true;
        backlight.enable = mkDefault true;
      };

      services = {
        xserver.libinput = {
          enable = true;
          touchpad = {
            clickMethod = "clickfinger";
            naturalScrolling = true;
          };
        };

        logind.lidSwitch = mkDefault "ignore";
      };

      environment = {
        variables.LAPTOP = "True";
        systemPackages = with pkgs; [ acpi ];
      };


    })
    (mkIf cfg.portable {
      modules.hardware = {
        gpu = {
          nvidia = mkDefault true;
          intel = mkDefault true;
          amdgpu = mkDefault true;
        };
        wireless.wifi.enable = true;
      };

      hardware.nvidia.powerManagement.enable = false;
    })
    (mkIf cfg.raspi {
      # imports = [ inputs.nixos-hardware.outputs.nixosModules.raspberry-pi-4 ];

      # modules.hardware = {
      #   wireless.enable = mkDefault true;
      # };

      # boot = {
      #   tmpOnTmpfs = true;
      #   kernelParams = [
      #     "8250.nr_uarts=1"
      #     "console=ttyAMA0,115200"
      #     "console=tty1"
      #   ];

      #   loader = {
      #     raspberryPi = {
      #       enable = true;
      #       version = 4;
      #     };

      #     grub.enable = false;
      #     generic-extlinux-compatible.enable = true;
      #   };
      # };

      # hardware.raspberry-pi."4" = {
      #   fkms-3d.enable = true;

      #   audio.enable = config.modules.hardware.audio.enable;
      # };

      # powerManagement.cpuFreqGovernor = "ondemand";

      # environment.systemPackages = with pkgs; [
      #   raspberrypi-eeprom
      # ];
    })
    (mkIf cfg.server { })
  ];
}
