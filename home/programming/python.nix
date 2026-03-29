{ pkgs, ... }:
{
  home.packages = with pkgs; [
    uv
    ruff

    (python314.withPackages (
      p: with p; [
        black
        isort
        jupyter
        mypy
        parallel-ssh
        pip
        pyflakes
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

  programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = {
    python = [
      "ruff_format"
      "ruff_organize_imports"
    ];
  };
}
