{ pkgs, lib, ... }:
{
  # Use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Remove all default packages
  environment.defaultPackages = lib.mkForce [ ];

  # Packages wanted everywhere
  environment.systemPackages = with pkgs; [
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
    exa
    exfat # Windows drives
    fd
    ffmpeg
    frei
    git
    htop
    iputils
    jq
    lynx
    man-pages
    man-pages-posix
    manix
    moreutils
    neofetch
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
    unzip
    usbutils
    util-linux
    vim
    wget
    whois
    xxHash
    zip
  ];
}
