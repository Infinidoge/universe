{ ... }: {
  console = {
    font = "Lat2-Terminus16";
    earlySetup = true;
    packages = [ ];
  };

  services.kmscon.enable = true;
}
