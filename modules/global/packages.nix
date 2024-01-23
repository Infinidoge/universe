{ config, pkgs, lib, ... }:
{
  # Use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Remove all default packages
  environment.defaultPackages = lib.mkForce [ ];

  # Packages wanted everywhere
  universe.packages = with pkgs; [
    universe-cli

    agenix
    bat
    cloc
    coreutils-doge
    cryptsetup
    curl
    direnv
    dnsutils
    erdtree
    eza
    fd
    htop
    hyfetch
    imagemagick
    iputils
    jq
    lynx
    man-pages
    man-pages-posix
    manix
    moreutils
    nmap
    parted
    perl
    rhash
    ripgrep
    rsync
    skim
    sshfs
    strace
    tealdeer
    tree
    unixtools.whereis
    unrar-wrapper
    unzip
    util-linux
    wget
    whois
    xxHash
    yq
    zip
  ] ++ (lib.optionals config.info.graphical (with pkgs; [
    yt-dlp
  ]));

  environment.systemPackages = config.universe.packages ++ (with pkgs; [
    binutils
    btrfs-progs
    compsize
    dosfstools
    exfat # Windows drives
    frei
    ntfs3g # Windows drives
    usbutils

    # covered by home manager
    git
    vim
  ]) ++ (lib.optionals config.info.graphical (with pkgs; [
    arandr
    ffmpeg
    mpv
  ]));
}
