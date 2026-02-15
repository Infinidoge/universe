{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pipenv
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

  programs.nixvim.plugins.lsp.servers.pylsp = {
    enable = true;
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
}
