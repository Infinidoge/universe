{ pkgs, ... }:
{
  fonts.packages = [
    pkgs.nerd-fonts.dejavu-sans-mono
  ];

  services.kmscon = {
    enable = true;
    useXkbConfig = true;
    config = {
      font-name = "DejaVuSansMono";
      font-size = 14;
    };
  };
}
