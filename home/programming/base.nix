{ pkgs, ... }:
{
  home.packages = with pkgs; [
    editorconfig-core-c
    editorconfig-checker
  ];
}
