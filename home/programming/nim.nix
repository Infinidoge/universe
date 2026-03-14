{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nim
  ];

  programs.nixvim.lsp.servers.nimls.enable = true;
}
