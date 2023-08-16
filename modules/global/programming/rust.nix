{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
      extensions = [
        "rust-src"
        "rust-analyzer"
      ];
    }))
    gcc
  ];
}
