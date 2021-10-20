{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; lib.lists.flatten [
    python3
    (with python39Packages; [
      pip
      black
      mypy
      jupyter
    ])
    python-language-server

    python310
  ];
}
