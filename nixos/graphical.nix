{ pkgs, home, ... }:
{
  environment.systemPackages = with pkgs; [
    # bitwarden-desktop # BUG: https://github.com/NixOS/nixpkgs/issues/526914
    gramma
    presenterm
    pyspread
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
