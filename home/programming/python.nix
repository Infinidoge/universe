{ pkgs, ... }:
{
  home.packages = with pkgs; [
    uv
    ruff
    ty

    (python314.withPackages (
      p: with p; [
        jupyter
        parallel-ssh
        pip
        pytest
      ]
    ))
  ];

  programs.nixvim.lsp.servers.pylsp = {
    enable = true;
    config = {
      filetypes = [
        "python"
        "xonsh"
      ];
      settings.pylsp.plugins = {
        autopep8.enable = false;
        rope.enable = true;
        rope_completion.enable = true;
      };
    };
  };

  programs.nixvim.lsp.servers.ruff = {
    enable = true;
    config = {
      filetypes = [
        "python"
        "xonsh"
      ];
      init_options.settings.configuration = {
        line-length = 120;
        select = [
          # pycodestyle
          "E"
          "W"

          # pyflakes
          "F"

          # isort
          "I"
        ];
      };
    };
  };

  programs.nixvim.lsp.servers.ty = {
    enable = true;
  };

  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = {
    python = [
      "ruff_format"
      "ruff_organize_imports"
    ];
  };
}
