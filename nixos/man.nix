{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix

    tealdeer
  ];
}
