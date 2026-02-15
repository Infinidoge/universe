{ pkgs, home, ... }:
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

  home-manager.sharedModules = with home; [
    ion
    nushell
    dotfiles.black

    programming.base
    programming.c
    programming.html
    programming.java
    programming.latex
    programming.nim
    programming.python
    programming.racket
    programming.rust
  ];
}
