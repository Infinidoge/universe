{
  config,
  pkgs,
  ...
}:
{
  xdg.configFile."qtile".source = pkgs.substituteSubset {
    src = ./qtile-config;
    files = [ "config.py" ];

    wallpaper = pkgs.fetchurl {
      name = "BotanWallpaper.jpg";
      # Source: https://www.pixiv.net/en/artworks/86093828
      url = "https://safebooru.org//images/3159/6c2d22b1fcac19a679de61f713c56503bca5aad9.jpg";
      sha256 = "sha256-3oVx9k+IN8GI8EWx3kPiQWdPGSO645abrEIL8C6sNq8=";
    };
    wallpaper_mode = "fill";
    firefox = config.programs.firefox.package.meta.mainProgram;
    locker = config.common.wm.locker.meta.mainProgram;
  };
}
