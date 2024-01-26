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
      { source = pkgs.fetchurl { url = "https://inx.moe/pub.txt"; sha256 = "sha256-QLxmqS5fbR3zqKNvFV+K22XeLuNfrSp2JxBDQtqgTiE="; }; trust = "ultimate"; }
    ];
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = (if main.services.xserver.enable then "qt" else "curses");
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };

  home.packages = with pkgs; [
    gpgme
  ];
}
