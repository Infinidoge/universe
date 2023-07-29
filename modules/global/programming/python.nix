{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; lib.lists.flatten [
    python310
    (with python310Packages; [
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
