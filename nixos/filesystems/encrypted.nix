{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cryptsetup
  ];
}
