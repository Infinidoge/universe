{ main, pkgs, lib, ... }:
let
  flattenTree = lib.our.flattenTree' (val: val ? action) "";

  mkLeader = { leader, mode }: name: value: {
    key = leader + name;
    inherit mode;
  } // value;

  mkLeaderMap = tree:
    builtins.concatMap
      (leader: lib.mapAttrsToList (mkLeader leader) (flattenTree tree))
      [
        { leader = "<leader>"; mode = [ "n" "v" ]; }
        { leader = "<M- >"; mode = [ "n" "v" "i" ]; }
      ];

  inherit (main.universe) programming;
  inherit (main) universe;
in
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

    globals.mapleader = " ";

    autoCmd = [
      { event = [ "TermOpen" ]; command = "setlocal nonumber norelativenumber"; }
    ];

    keymaps = [
      {
        key = "<Space>";
        action = "<Nop>";
        mode = [ "n" "v" ];
        options = {
          silent = true;
        };
      }
      {
        key = "<C-w>n";
        action = "<C-\\><C-n>";
        mode = "t";
      }
    ] ++ mkLeaderMap {
      c = {
        a.action.__raw = "vim.lsp.buf.code_action";
        f.action = ":Format<Enter>";
        t = {
          f.action = ":FormatToggle<Enter>";
        };
      };
      w = {
        q.action = ":close<Enter>";
        d.action = ":close<Enter>";
        v.action = ":vsplit<Enter>";
        s.action = ":split<Enter>";
        V.action = ":vsplit ";
        S.action = ":split ";
        n.action = ":next<Enter>";
        p.action = ":previous<Enter>";
      };
      f = {
        s.action = ":w<enter>";
      };
      q = {
        q.action = ":q<Enter>";
        Q.action = ":q!<Enter>";
        x.action = ":x<Enter>";
      };
    };

    plugins = {
      autoclose = {
        enable = true;
        options.disableWhenTouch = true;
      };
      comment.enable = true;
      cmp.enable = true;
      cursorline.enable = true;
      direnv.enable = true;
      fidget.enable = true;
      fzf-lua.enable = true;
      gitsigns.enable = true;
      hydra = {
        enable = true;
      };
      image.enable = universe.media.enable;
      lsp-format.enable = true;
      mkdnflow = {
        enable = true;
      };
      neorg = {
        enable = true;
        settings = {
          load = let empty = { __empty = null; }; in {
            "core.defaults" = empty;
            "core.concealer" = empty;
          };
        };

      };
      nix.enable = true;
      # nvim-autopairs.enable = true;
      vim-surround.enable = true;
      todo-comments.enable = true;
      treesitter-context.enable = false;
      treesitter = {
        enable = true;
        folding = false;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      ts-autotag.enable = true;
      ts-context-commentstring.enable = true;
      typst-vim.enable = true;

      #nvim-jdtls.enable = true;

      lsp = {
        enable = true;
        servers = {
          clangd.enable = programming.c.enable;
          hls = {
            enable = programming.haskell.enable;
            installGhc = false;
          };
          lua_ls.enable = programming.lua.enable;
          marksman.enable = true;
          # Try nixd
          nil_ls = {
            enable = true;
            extraOptions = {
              settings.nil.formatting.command = [ "nixfmt" ];
            };
          };
          nimls.enable = programming.nim.enable;
          pylsp = {
            enable = programming.python.enable;
            settings = {
              plugins = {
                autopep8.enable = false;
                ruff = {
                  formatEnabled = true;
                  enable = true;
                  format = [ "I" ];
                  extendSelect = [ "I" ];

                  lineLength = 120;
                  select = [ "F" ];
                };
                rope.enable = true;
                rope_completion.enable = true;
              };
            };
          };
          rust_analyzer = {
            enable = programming.rust.enable;
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
      vim.cmd [[cabbrev Q q]]
      vim.cmd [[cabbrev W w]]
      vim.cmd [[cabbrev WQ wq]]
      vim.cmd [[cabbrev X x]]
    '';
  };
}
