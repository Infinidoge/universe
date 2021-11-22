{ config, options, lib, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.modules.boot;
  opt = options.modules.boot;
in
{
  options.modules.boot = with types; {
    timeout = mkOpt (nullOr int) 3;

    grub = {
      enable = mkBoolOpt false;
    };
    systemd-boot.enable = mkBoolOpt false;
  };

  config = mkMerge [
    {
      assertions = [
        {
          assertion = (count (v: v) [ cfg.grub.enable cfg.systemd-boot.enable ]) == 1;
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
          efiSysMountPoint = mkDefault "/boot/efi";
        };
      };
    })
    (mkIf cfg.systemd-boot.enable {
      boot.loader = {
        systemd-boot = {
          enable = mkDefault true;
          editor = false;
          consoleMode = "2";
        };

        efi.canTouchEfiVariables = true;
      };
    })
  ];
}
