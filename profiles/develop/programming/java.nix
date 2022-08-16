{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    openjdk17
    clang-tools
  ];
}
