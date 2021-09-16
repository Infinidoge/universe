{ pkgs, ... }: {
  console = {
    font = "DejaVuSansMono";
    earlySetup = true;
    packages = with pkgs; [ (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; }) ];
  };

  services.kmscon = {
    enable = true;
    extraConfig = [
      "font-size=14"
    ];
  };
}
