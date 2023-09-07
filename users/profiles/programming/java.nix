{ pkgs, ... }: {
  home.packages = with pkgs; [
    openjdk19
    clang-tools
    gradle
  ];
}
