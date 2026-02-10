{
  pkgs,
  lib,
  common,
  home,
  ...
}:
{
  info = {
    graphical = true;
    monitors = lib.mkDefault 1;
    env.wm = "qtile";
  };

  common.wm = {
    locker = pkgs.xsecurelock;
  };

  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
  };

  programs.xss-lock = {
    enable = true;
    lockerCommand = lib.getExe common.wm.locker;
  };

  services.autorandr = {
    enable = true;
    ignoreLid = true;
    defaultTarget = "horizontal";
  };

  services.xserver.enable = true;
  services.xserver.enableTearFree = true;

  services.xserver.displayManager = {
    lightdm.enable = true;
    setupCommands = "${lib.getExe pkgs.autorandr} -c";
  };

  home-manager.sharedModules = with home; [
    { xsession.enable = true; }

    dotfiles.qtile

    communication
    dunst
    firefox
    flameshot
    kitty
    media
    themeing
  ];

  environment.systemPackages = with pkgs; [
    common.wm.locker

    xorg.xwininfo
    xorg.xprop
    xclip
    xdotool
    pavucontrol
    arandr
  ];

  services.xserver.windowManager.qtile = {
    enable = true;
    extraPackages =
      p: with p; [
        qtile-extras
      ];
  };

  fonts.packages = with pkgs; [
    powerline-fonts
    ubuntu-classic
  ];
}
