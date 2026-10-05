{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clang-tools
    gradle_9
  ];

  programs.java.enable = true;
  programs.java.package = pkgs.openjdk25;

  # consider setting up jdtls in neovim
}
