{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Use the latest Linux kernel
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # Remove all default packages
  environment.defaultPackages = lib.mkForce [ ];

  # Packages wanted everywhere
  universe.packages =
    with pkgs;
    [
      universe-cli

      bat
      cloc
      cryptsetup
      curl
      difftastic
      direnv
      dnsutils
      erdtree
      eza
      fd
      fzf
      gnumake
      gptfdisk
      gum
      htop
      hyfetch
      iputils
      jq
      man-pages
      man-pages-posix
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
      unixtools.whereis
      unrar-wrapper
      unzip
      util-linux
      wget
      whois
      xxHash
      yq
      zip
    ]
    ++ (lib.optionals config.universe.media.enable (
      with pkgs;
      [
        ghostscript
        graphviz
        imagemagick
        pandoc
        yt-dlp
      ]
    ));

  environment.systemPackages =
    config.universe.packages
    ++ (with pkgs; [
      binutils
      btrfs-progs
      bubblewrap
      compsize
      coreutils-doge
      dosfstools
      exfat # Windows drives
      kitty.terminfo
      ntfs3g # Windows drives
      smartmontools
      usbutils

      # covered by home manager
      git
      vim
    ])
    ++ (lib.optionals config.info.graphical (
      with pkgs;
      [
        arandr
      ]
    ))
    ++ (lib.optionals config.universe.media.enable (
      with pkgs;
      [
        ffmpeg-full
        mpv
      ]
    ));
}
