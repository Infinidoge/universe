{ pkgs, ... }:
{
  home.packages = with pkgs; [
    racket
  ];
}
