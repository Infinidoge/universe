{ config, lib, pkgs, ... }:
with lib;
with lib.our;
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
      modules.hardware.peripherals.yubikey.enable = true;
      info.stationary = mkDefault true;
    })

    (mkIf cfg.laptop {
      modules.hardware = {
        wireless.enable = mkDefault true;
        audio.enable = mkDefault true;
        peripherals.yubikey.enable = true;
      };

      hardware = {
        acpilight.enable = true;
      };

      services = {
        libinput.touchpad = {
          clickMethod = "clickfinger";
          naturalScrolling = true;
        };

        logind.lidSwitch = mkDefault "suspend-then-hibernate";
        logind.lidSwitchExternalPower = mkDefault "ignore";

        tlp.enable = mkDefault true;

        upower = {
          enable = true;
          criticalPowerAction = "Hibernate";
        };
      };

      powerManagement = {
        cpuFreqGovernor = mkDefault "powersave";
        powertop.enable = mkDefault true;
      };

      environment = {
        variables.LAPTOP = "True";
        systemPackages = with pkgs; [ acpi brightnessctl ] ++ optional config.powerManagement.powertop.enable pkgs.powertop;
      };

      persist.directories = [
        "/var/lib/systemd/backlight"
      ];
    })

    (mkIf cfg.portable {
      modules.hardware = {
        wireless.enable = true;
        peripherals.yubikey.enable = true;
      };
    })

    (mkIf cfg.raspi {
      boot.loader.grub.enable = false;
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

    (mkIf cfg.server {
      info = {
        monitors = mkDefault 0;
        model = mkDefault "Headless Server";
        stationary = mkDefault true;
      };
    })
  ];
}
