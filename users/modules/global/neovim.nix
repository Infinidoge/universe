{ config, pkgs, lib, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    opts = {
      termguicolors = true;
      number = true;
      relativenumber = true;
      ignorecase = true;
      smartcase = true;
      mouse = "a";
      tabstop = 4;
      shiftwidth = 4;
      clipboard = "unnamedplus,unnamed";
      directory = [
        "~/.local/share/vim/swap//"
        "."
      ];
    };

    globals = {
      doom_one_cursor_coloring = true;
      doom_one_terminal_colors = true;
      doom_one_italic_comments = false;
      doom_one_enable_treesitter = true;
    };

    colorscheme = "doom-one";
    extraPlugins = with pkgs.vimPlugins; [
      doom-one-nvim
    ];

    globals.mapleader = "<space>";

    autoCmd = [
      { event = [ "TermOpen" ]; command = "setlocal nonumber norelativenumber"; }
    ];

    keymaps = [
      { key = "<C-w> n"; action = "<C-\\><C-n>"; mode = "t"; }
    ];

    plugins = {
      comment.enable = true;
      direnv.enable = true;
      gitsigns.enable = true;
      # lsp.enable = true;
      # nix.enable = true;
      # nvim-autopairs.enable = true;
      surround.enable = true;
      todo-comments.enable = true;
      treesitter-context.enable = false;
      treesitter.enable = true;
      ts-autotag.enable = true;
      ts-context-commentstring.enable = true;
    };
  };
}
