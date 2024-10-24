{ pkgs, ... }:
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
    };

    clipboard.register = [ "unnamedplus" "unnamed" ];

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
      {
        key = "<C-w> n";
        action = "<C-\\><C-n>";
        mode = "t";
      }
      {
        key = "<M-CR>";
        action.__raw = "vim.lsp.buf.code_action";
        mode = [ "n" "i" "v" "s" ];
      }
    ];

    plugins = {
      autoclose = {
        enable = true;
        options.disableWhenTouch = true;
      };
      comment.enable = true;
      cursorline.enable = true;
      direnv.enable = true;
      fidget.enable = true;
      fzf-lua.enable = true;
      gitsigns.enable = true;
      nix.enable = true;
      lsp-format.enable = true;
      # nvim-autopairs.enable = true;
      vim-surround.enable = true;
      todo-comments.enable = true;
      treesitter-context.enable = false;
      treesitter = {
        enable = true;
        folding = false;
      };
      ts-autotag.enable = true;
      ts-context-commentstring.enable = true;
      typst-vim.enable = true;

      #nvim-jdtls.enable = true;

      lsp = {
        enable = true;
        servers = {
          clangd.enable = true;
          hls.enable = true;
          lua_ls.enable = true;
          nil_ls = {
            enable = true;
            extraOptions = {
              settings.nil.formatting.command = [ "nixpkgs-fmt" ];
            };
          };
          nimls.enable = true;
          pylsp = {
            enable = true;
            settings = {
              plugins = {
                ruff = {
                  formatEnabled = true;
                  enable = true;
                  format = [ "I" ];
                };
                rope.enable = true;
              };
            };
          };
          rust_analyzer = {
            enable = true;
            installRustc = false;
            installCargo = false;
          };
          typst_lsp.enable = false;
        };
      };
    };

    extraConfigLua = ''
      vim.cmd [[cabbrev wq execute "Format sync" <bar> wq]]
      vim.cmd [[cabbrev x execute "Format sync" <bar> x]]
    '';
  };
}
