{ pkgs, lib, ... }: {
  home.packages = with pkgs; lib.lists.flatten [
    kotlin
    kotlin-language-server
  ];
}
