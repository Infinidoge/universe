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
    browsh
    cloc
    coreutils-doge
    cryptsetup
    curl
    difftastic
    direnv
    dnsutils
    erdtree
    eza
    fd
    fzf
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
    openssl
    parallel
    parted
    pciutils
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
    bubblewrap
    compsize
    dosfstools
    exfat # Windows drives
    kitty.terminfo
    ntfs3g # Windows drives
    smartmontools
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
