{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ocaml
    ocamlformat
    dune

    ocamlPackages.utop
    ocamlPackages.ocp-indent
  ];

  programs.nixvim.lsp.servers.ocamllsp = {
    enable = true;
  };

  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    vim-ocaml
  ];
}
