{ pkgs, ... }: {
  imports = [ ./xserver.nix ];

  services.xserver.windowManager.qtile.enable = true;

  environment.systemPackages = with pkgs; [ xsecurelock ];
}
