{ private, ... }:
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
{
  hardware.printers = {
    ensureDefaultPrinter = "printing";
    ensurePrinters = [
      (itap "printing")
      (itap "colorprinting")
    ];
  };

  services.printing.browsedConf = ''
    BrowseRemoteProtocols none
  '';
}
