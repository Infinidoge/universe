{ config, pkgs, lib, ... }:
{
  # Use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Remove all default packages
  environment.defaultPackages = lib.mkForce [ ];

  # Packages wanted everywhere
  environment.systemPackages = with pkgs; [
    universe-cli

    agenix
    bat
    binutils
    btrfs-progs
    cloc
    coreutils-doge
    curl
    direnv
    dnsutils
    dosfstools
    erdtree
    eza
    exfat # Windows drives
    fd
    frei
    git
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
    ntfs3g # Windows drives
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
    usbutils
    util-linux
    vim
    wget
    whois
    xxHash
    yq
    zip
  ] ++ (lib.optionals config.info.graphical (with pkgs; [
    arandr
    ffmpeg
    mpv
    yt-dlp
  ]));
}
