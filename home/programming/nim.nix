{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nim
  ];
}
