{ pkgs, ... }:
{
  services.kmscon = {
    enable = true;
    hwRender = true;
    useXkbConfig = true;
    fonts = [
      (rec {
        name = "DejaVuSansMono";
        package = (pkgs.nerdfonts.override { fonts = [ name ]; });
      })
    ];
    extraConfig = ''
      font-size=14
    '';
  };
}
