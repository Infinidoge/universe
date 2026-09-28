{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clang-tools
    gradle
  ];

  programs.java.enable = true;
  programs.java.package = pkgs.openjdk25;

  # consider setting up jdtls in neovim
}
