{ config, options, lib, ... }:
with lib;
with lib.our;
let
  cfg = config.modules.boot;
  opt = options.modules.boot;
in
{
  options.modules.boot = with types; {
    timeout = mkOpt (nullOr int) 3;

    grub = {
      enable = mkBoolOpt false;
      efiSysMountPoint = mkOpt path "/boot/efi";
    };
    systemd-boot.enable = mkBoolOpt false;
    ignore = mkBoolOpt false;
  };

  config = mkMerge [
    {
      assertions = [
        {
          assertion = (count (v: v) [ cfg.grub.enable cfg.systemd-boot.enable config.wsl.enable cfg.ignore ]) == 1;
          message = "Must enable one and only one bootloader";
        }
      ];

      boot.loader.timeout = mkAliasDefinitions opt.timeout;
    }
    (mkIf cfg.grub.enable {
      boot.loader = {
        grub = {
          enable = mkDefault true;
          device = mkDefault "nodev";
          efiSupport = mkDefault true;
          useOSProber = mkDefault false;
          efiInstallAsRemovable = mkDefault true;
        };
        efi = {
          canTouchEfiVariables = mkDefault false;
          efiSysMountPoint = cfg.grub.efiSysMountPoint;
        };
      };
    })
    (mkIf cfg.systemd-boot.enable {
      boot.loader = {
        systemd-boot = {
          enable = mkDefault true;
          consoleMode = "2";

          # See desc in nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
          editor = false;
        };

        efi.canTouchEfiVariables = true;
      };
    })
  ];
}
