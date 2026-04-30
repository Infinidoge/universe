{ pkgs, ... }:
{
  home.packages = with pkgs; [
    html-tidy
    prettier
  ];
}
