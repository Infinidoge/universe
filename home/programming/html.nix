{ pkgs, ... }:
{
  home.packages = with pkgs; [
    html-tidy
    nodePackages.prettier
  ];
}
