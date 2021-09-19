{ pkgs, ... }: {
  console = {
    font = "Lat2-Terminus16";
    earlySetup = true;
    packages = with pkgs; [ (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; }) ];
  };

  services.kmscon = {
    enable = true;
    hwRender = true;
    extraConfig = ''
      font-size=14
      font-name=DejaVuSansMono
    '';
  };
}
