{ pkgs, lib, ... }: {
  home.packages = with pkgs; lib.lists.flatten [
    lua-language-server
  ];
}
