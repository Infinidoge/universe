{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    android-tools
    go-mtpfs
  ];
}
