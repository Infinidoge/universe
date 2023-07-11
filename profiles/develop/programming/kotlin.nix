{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; lib.lists.flatten [
    kotlin
    kotlin-language-server
  ];
}
