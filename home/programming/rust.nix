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

  programs.nixvim.lsp.servers.rust_analyzer = {
    enable = true;
    package = null; # get rust_analyzer from PATH
  };
}
