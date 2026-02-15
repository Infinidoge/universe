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

  programs.nixvim.plugins.lsp.servers.rust_analyzer = {
    enable = true;
    installRustc = false;
    installCargo = false;
  };
}
