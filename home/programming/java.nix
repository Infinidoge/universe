{ pkgs, ... }:
{
  home.packages = with pkgs; [
    openjdk
    clang-tools
    gradle
  ];

  programs.java.enable = true;

  # consider setting up jdtls in neovim
}
