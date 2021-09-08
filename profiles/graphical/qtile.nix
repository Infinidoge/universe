{ pkgs, ... }: {
  imports = [ ./xserver ];

  services.xserver.windowManager.qtile.enable = true;

  environment.systemPackages = with pkgs; [ xsecurelock ];
}
