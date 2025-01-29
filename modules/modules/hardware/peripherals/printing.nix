{
  config,
  lib,
  private,
  ...
}:
with lib;
with lib.our;
let
  cfg = config.modules.hardware.peripherals.printing;
in
{
  options.modules.hardware.peripherals.printing = with types; {
    enable = mkBoolOpt false;
    drivers = mkOpt (listOf path) [ ];
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.printing = {
        enable = true;
        inherit (cfg) drivers;
      };
    }

    (mkIf config.info.loc.purdue {
      hardware.printers = {
        ensureDefaultPrinter = "printing";

        ensurePrinters =
          let
            itap = name: {
              inherit name;
              #deviceUri = "lpd://${private.variables.purdue-username}@wpvapppcprt02.itap.purdue.edu:515/itap-${name}";
              deviceUri = "lpd://${private.variables.purdue-username}@128.210.210.41:515/itap-${name}";
              model = "drv:///sample.drv/generic.ppd";
              ppdOptions = {
                Duplex = "DuplexNoTumble";
                Option1 = "True"; # Duplexer
              };
            };
          in
          [
            (itap "printing")
            (itap "colorprinting")
          ];
      };

      services.printing.browsedConf = ''
        BrowseRemoteProtocols none
      '';
    })
  ]);
}
