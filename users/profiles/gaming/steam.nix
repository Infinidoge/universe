{ pkgs, ... }: {
  home.packages = with pkgs; [
    (steam.override {
      extraPkgs = pkgs: with pkgs; [ pango harfbuzz libthai ];
    })
  ];
}
