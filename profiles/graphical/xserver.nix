{ pkgs, lib, ... }: {
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm.enable = true;
      importedVariables = [ "DOOMDIR" ];
    };
  };

  environment.systemPackages = with pkgs; [
    xclip
    xdotool
    xorg.xwininfo
    xorg.xauth

    blugon
  ];

  info.monitors = lib.mkDefault 1;
}
