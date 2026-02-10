{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gcc

    (rust-bin.selectLatestNightlyWith (
      toolchain:
      toolchain.default.override {
        extensions = [
          "rust-src"
          "rust-analyzer"
        ];
      }
    ))
  ];
}
