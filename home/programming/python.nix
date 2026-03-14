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
    };
  };
}
