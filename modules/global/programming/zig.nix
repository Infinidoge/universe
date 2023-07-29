{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    zig
    zls
  ];
}
