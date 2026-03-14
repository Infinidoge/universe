{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gcc
    gdb
    clang-tools
    binutils
    valgrind
  ];

  programs.nixvim.lsp.servers.clangd.enable = true;
}
