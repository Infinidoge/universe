{
  lib,
  config,
  pkgs,
  home,
  ...
}:
{
  # Use the latest Linux kernel
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  # Remove all default packages
  environment.defaultPackages = lib.mkForce [ ];

  environment.systemPackages = with pkgs; [
    # main terminal
    kitty.terminfo

    # the bare minimum
    git
    vim

    # preferred terminal tools
    bat
    curl
    direnv
    erdtree
    eza
    fd
    fzf
    gnumake
    jq
    rhash
    ripgrep
    skim
    xxhash

    # networking tools
    dnsutils
    iputils
    nmap
    openssl
    rsync
    sshfs
    wget

    # hardware
    pciutils
    usbutils
    util-linux

    # disk
    dosfstools
    gptfdisk
    parted
    smartmontools

    # debugging
    strace

    # misc
    htop
    hyfetch
    unzip
    zip
  ];

  # Ensure certain necessary directories always exist
  systemd.tmpfiles.rules = [
    "d /mnt 0777 root root - -"
  ];

  security.sudo = {
    # FIXME: Maybe don't do passwordless sudo
    wheelNeedsPassword = false;
    extraConfig = "Defaults lecture=never";
  };

  security.pki.certificateFiles = [
    (pkgs.fetchurl {
      url = "https://files.inx.moe/ca/ca.cert.pem";
      hash = "sha256-YZKiWLnO7uSHYJeNfTVxN87xMSPbJC7iTif3lMtUxpI=";
    })
    (pkgs.fetchurl {
      url = "https://files.inx.moe/ca/intermediate.cert.pem";
      hash = "sha256-NpVi8Uv2IaxCq+laQp+YL1xrJeIFeDZv5SKAWT1bzGQ=";
    })
  ];

  users.mutableUsers = false;

  # Allow non-root users to allow other users to access mount point
  programs.fuse.userAllowOther = true;

  # Prevent wrapped PATH dependencies from affecting user shell PATH
  environment.interactiveShellInit = ''
    if [[ "$(basename "$(readlink "/proc/$PPID/exe")")" == ".kitty-wrapped" ]]; then
      PATH=$(echo "$PATH" | sed 's/\/nix\/store\/[a-zA-Z._0-9+-]\+\/bin:\?//g' | sed 's/:$//')
    fi
  '';

  services.timesyncd.extraConfig = "FallbackNTP=162.159.200.1 2606:4700:f1::1"; # time.cloudflare.com

  security.polkit.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
    cpu.amd.updateMicrocode = true;
  };

  # TODO: Move this somewhere else
  services.minecraft-servers.eula = true;

  networking.hostId = builtins.substring 0 8 (
    builtins.hashString "sha256" config.networking.hostName
  );

  programs.zsh.enable = true;
  programs.xonsh.enable = true;

  # Disable man cache
  # I don't use it, and it takes ages on rebuild
  documentation.man.cache.enable = lib.mkForce false;
  home-manager.sharedModules = with home; [
    { programs.man.generateCaches = lib.mkForce false; }

    shells.bash
    shells.zsh
    shells.xonsh
    base
    direnv
    git
    gpg
    htop
    neovim
    programming.nix
    nix-index
    ssh
    starship
    tealdeer
    tmux
    vim
    zoxide
    dotfiles.neofetch
  ];
}
