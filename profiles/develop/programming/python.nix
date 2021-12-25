{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; lib.lists.flatten [
    python3
    python310
    (with python39Packages; [
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
    python-language-server
    pipenv
  ];
}
