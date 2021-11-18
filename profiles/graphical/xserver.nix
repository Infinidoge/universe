{ pkgs, lib, ... }: {
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
  };

  environment.systemPackages = with pkgs; lib.flatten [
    (with xorg; [
      xwininfo
      xprop
    ])

    blugon
  ];

  info.monitors = lib.mkDefault 1;
}
