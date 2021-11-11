{ pkgs, ... }: {
  programs.nnn = {
    enable = true;
    bookmarks = { };
    extraPackages = with pkgs; [
      ffmpegthumbnailer
      mediainfo
      sxiv
    ];
  };
}
