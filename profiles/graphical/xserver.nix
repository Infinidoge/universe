{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    layout = "us";
  };

  environment.systemPackages = with pkgs; [
    xclip
    xdotool
    xorg.xwininfo
    xorg.xauth

    blugon
  ];
}
