{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nim
    nimlsp
  ];
}
