{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; lib.lists.flatten [
    lua-language-server
  ];
}
