{
  config,
  pkgs,
  ...
}:
{
  xdg.configFile."qtile/config.py".source =
    config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/dotfiles/qtile/config.py";

  xdg.configFile."qtile/nix.json".source = (pkgs.formats.json { }).generate "nix.json" {
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

  # BUG: Discord (and maybe some other applications)
  # scale the cursor when they shouldn't, making it very large
  # This forces a cursor size which doesn't fix it, but does make it
  # less noticable
  home.sessionVariables = {
    "XCURSOR_SIZE" = 12;
  };

}
