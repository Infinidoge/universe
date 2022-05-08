{ pkgs, ... }: {
  imports = [ ./xserver.nix ];

  services.xserver.windowManager.qtile.enable = true;

  info.env.wm = "qtile";

  environment.systemPackages = with pkgs; [
    xsecurelock
  ];

  fonts.fonts = with pkgs; [
    powerline-fonts
    ubuntu_font_family
  ];
}
