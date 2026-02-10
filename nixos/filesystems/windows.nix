{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    exfat
    ntfs3g
  ];
}
