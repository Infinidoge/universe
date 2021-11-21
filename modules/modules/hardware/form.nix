{ config, lib, ... }:
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
      modules.hardware.audio.enable = true;
    })
    (mkIf cfg.laptop {
      modules.hardware.audio.enable = true;

      services = {
        xserver.libinput = {
          enable = true;
          touchpad.naturalScrolling = true;
        };

        logind.lidSwitch = "ignore";
      };

      environment = {
        variables.LAPTOP = "True";
        systemPackages = with pkgs; [ acpi ];
      };


    })
    (mkIf cfg.portable { })
    (mkIf cfg.raspi { })
    (mkIf cfg.server { })
  ];
}
