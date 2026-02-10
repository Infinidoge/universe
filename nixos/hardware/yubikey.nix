{ pkgs, ... }:
{
  # FIXME: Detangle home manager

  home.home.packages = with pkgs; [
    yubikey-manager
    yubikey-personalization
    yubico-piv-tool
    yubioath-flutter
  ];

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;
}
