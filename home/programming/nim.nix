{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nim
  ];

  programs.nixvim.plugins.lsp.servers.nimls.enable = true;
}
