{ config, main, pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";

    settings = {
      no-comments = false;
      comment = [
        "Key URL: https://inx.moe/pub.txt"
        "Website: https://inx.moe"
      ];
    };

    scdaemonSettings = {
      disable-ccid = true;
    };

    publicKeys = [
      { source = pkgs.fetchurl { url = "https://inx.moe/pub.txt"; sha256 = "sha256-Eocb+3TbeWmwkxQNQ3XKmRi5N9vz7QoLni0b8b0zw2k="; }; trust = "ultimate"; }
    ];
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = (if main.info.graphical then pkgs.pinentry-qt else pkgs.pinentry-curses);
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };

  home.packages = with pkgs; [
    gpgme
  ];
}
