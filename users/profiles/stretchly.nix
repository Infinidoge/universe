{ pkgs, ... }: {
  home.packages = with pkgs; [ stretchly ];
}
