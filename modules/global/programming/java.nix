{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    openjdk19
    clang-tools
    gradle
  ];
}
