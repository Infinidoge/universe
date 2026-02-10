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
}
