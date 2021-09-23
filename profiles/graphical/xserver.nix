{ pkgs, lib, ... }: {
  services.xserver.enable = true;

  environment.systemPackages = with pkgs; [
    xclip
    xdotool
    xorg.xwininfo
    xorg.xauth

    blugon
  ];

  info.monitors = lib.mkDefault 1;
}
