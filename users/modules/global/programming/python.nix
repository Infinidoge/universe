{ pkgs, lib, ... }: {
  home.packages = with pkgs; lib.lists.flatten [
    python311
    (with python311Packages; [
      black
      isort
      jupyter
      mypy
      nose
      pip
      pyflakes
      pyls-isort
      pytest
    ])
    pyright
    pipenv
  ];
}
