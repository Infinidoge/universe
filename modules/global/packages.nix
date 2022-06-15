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
    coreutils-doge
    curl
    direnv
    dnsutils
    dosfstools
    exfat # Windows drives
    fd
    ffmpeg
    git
    htop
    iputils
    jq
    lynx
    manix
    moreutils
    neofetch
    nmap
    ntfs3g # Windows drives
    parted
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
    utillinux
    vim
    wget
    whois
    xxHash
    zip
  ];
}
