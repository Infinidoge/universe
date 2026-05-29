{ pkgs, home, ... }:
{
  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    gramma
    presenterm
    qbittorrent
    speedcrunch
    sqlitebrowser
    toot
  ];

  # Enable dconf for programs that need it
  programs.dconf.enable = true;

  services.earlyoom = {
    enable = true;
    enableNotifications = true;
  };

  services.systembus-notify.enable = true;

  # FIXME: detangle
  home.services.gpg-agent.pinentry.package = pkgs.pinentry-rofi;

  home-manager.sharedModules = with home; [
    rofi
  ];
}
