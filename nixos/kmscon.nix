{ pkgs, ... }:
{
  services.kmscon = {
    enable = true;
    hwRender = false;
    useXkbConfig = true;
    fonts = [
      {
        name = "DejaVuSansMono";
        package = pkgs.nerd-fonts.dejavu-sans-mono;
      }
    ];
    extraConfig = ''
      font-size=14
    '';
  };
}
