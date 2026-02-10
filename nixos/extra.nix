{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    binutils
    bubblewrap
    cloc
    coreutils-doge
    gum
    unixtools.whereis
    unrar-wrapper
    whois
    yq
    htmlq

    bitwarden-cli
    bsd-finger
    ncdu
    peaclock
    pop
    qrencode
    reflex
    unison
  ];
}
