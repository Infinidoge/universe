{
  main,
  pkgs,
  lib,
  ...
}:
let
  flattenTree = lib.our.flattenTree' (val: val ? action) "";

  mkLeader =
    { leader, mode }:
    name: value:
    {
      key = leader + name;
      inherit mode;
    }
    // value;

  mkLeaderMap =
    tree:
    builtins.concatMap (leader: lib.mapAttrsToList (mkLeader leader) (flattenTree tree)) [
      {
        leader = "<leader>";
        mode = [
          "n"
          "v"
        ];
      }
      {
        leader = "<M- >";
        mode = [
          "n"
          "v"
          "i"
        ];
      }
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
      spell = true;
      spelllang = [ "en_us" ];
    };

    clipboard.register = [
      "unnamedplus"
      "unnamed"
    ];

    globals = {
      doom_one_cursor_coloring = true;
      doom_one_terminal_colors = true;
      doom_one_italic_comments = false;
      doom_one_enable_treesitter = true;
    };

    colorscheme = "doom-one";

    extraPlugins = with pkgs.vimPlugins; [
      doom-one-nvim
      (pkgs.vimUtils.buildVimPlugin {
        name = "vim-xonsh";
        src = pkgs.fetchFromGitHub {
          owner = "meatballs";
          repo = "vim-xonsh";
          rev = "929f35e37ad7dbdec80b1effe295b89c9ac3f090";
          hash = "sha256-ugHLu2Z9bTtQsIp4FQPKxgjVe9oZNjfQYrP+aHu+/uU=";
        };
      })
    ];

    globals.mapleader = " ";

    autoCmd = [
      {
        event = [ "TermOpen" ];
        command = "setlocal nonumber norelativenumber";
      }
    ];

    keymaps =
      [
        {
          key = "<Space>";
          action = "<Nop>";
          mode = [
            "n"
            "v"
          ];
          options = {
            silent = true;
          };
        }
        {
          key = "<C-w>n";
          action = "<C-\\><C-n>";
          mode = "t";
        }
      ]
      ++ mkLeaderMap {
        c = {
          a.action.__raw = "vim.lsp.buf.code_action";
          l = {
            d.action.__raw = "vim.diagnostic.open_float";
            "[".action.__raw = "vim.diagnostic.goto_prev";
            "]".action.__raw = "vim.diagnostic.goto_next";
            l.action.__raw = "vim.diagnostic.setloclist";
          };
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
        enable = false;
        settings.options.disable_when_touch = true;
      };
      blink-cmp = {
        enable = true;
        settings = {
          completion = {
            accept = {
              auto_brackets = {
                enabled = true;
              };
            };
          };
          keymap = {
            preset = "default";
            "<Up>" = [
              "select_prev"
              "fallback"
            ];
            "<Down>" = [
              "select_next"
              "fallback"
            ];
            "<CR>" = [
              "accept"
              "fallback"
            ];
          };
          signature = {
            enabled = true;
          };
          sources = {
            default = [
              "lsp"
              "path"
              "snippets"
              "buffer"
              "spell"
            ];
            providers = {
              spell = {
                module = "blink-cmp-spell";
                name = "Spell";
                score_offset = 100;
              };
            };
          };
        };
      };
      blink-cmp-spell.enable = true;
      comment.enable = true;
      cursorline.enable = true;
      direnv.enable = true;
      fidget.enable = true;
      fzf-lua.enable = true;
      gitsigns.enable = true;
      hydra = {
        enable = true;
      };
      image = {
        inherit (universe.media) enable;
        settings = {
          integrations = {
            markdown = {
              only_render_image_at_cursor = true;
              only_render_image_at_cursor_mode = "popup";
            };
          };
        };
      };
      lsp-format.enable = true;
      mkdnflow = {
        enable = true;
      };
      nix.enable = true;
      nvim-autopairs.enable = true;
      oil.enable = true;
      otter.enable = true;
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
            package = pkgs.nil;
            extraOptions = {
              settings.nil.formatting.command = [ "nixfmt" ];
            };
          };
          nimls.enable = programming.nim.enable;
          pylsp = {
            enable = programming.python.enable;
            filetypes = [
              "python"
              "xonsh"
            ];
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
