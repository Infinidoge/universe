{ pkgs, home, ... }:
{
  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    presenterm
    qbittorrent
    speedcrunch
    sqlitebrowser
    toot
    gramma
  ];

  # Enable dconf for programs that need it
  programs.dconf.enable = true;

  services.earlyoom = {
    enable = true;
    enableNotifications = true;
  };

  # FIXME: detangle
  home.services.gpg-agent.pinentry.package = pkgs.pinentry-qt;

  home-manager.sharedModules = with home; [
    rofi
  ];
}
