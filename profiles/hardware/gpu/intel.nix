{ pkgs, ... }: {
  imports = [ ./common.nix ];

  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
    vaapiIntel
  ];
}
