{ pkgs, ... }: {
  imports = [ ./common.nix ];

  services.xserver.videoDrivers = [ "intel" ];

  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
    vaapiIntel
  ];
}
