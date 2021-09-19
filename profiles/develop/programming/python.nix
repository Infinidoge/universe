{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    python3
    python310
    python39Packages.pip
    python39Packages.black
    python-language-server
  ];
}
