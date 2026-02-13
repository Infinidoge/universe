{
  lib,
  config,
  pkgs,
  ...
}:
let
  editi = (
    pkgs.writeScriptBin "editi" ''
      if [[ $# -eq 0 ]] then
        fd -H -E .git -t f | fzf --filepath-word --multi | xargs -r $EDITOR
      else
        fd -H -E .git -t f | fzf --filepath-word --multi -1 -q "$*" | xargs -r $EDITOR
      fi
    ''
  );
in

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
    xxHash

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

    # custom
    universe-cli
    editi
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

  environment.shellAliases = {
    sudo = "sudo -E ";
    s = "sudo ";
    si = "sudo -i";
    se = "sudoedit";

    lsdisk = "lsblk -o name,size,mountpoints,fstype,label,fsavail,fsuse%";
    lsdisks = "lsblk -o name,size,fstype,label,uuid,fsavail,fsuse%";

    uni = "universe-cli";

    # quick cd
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    # ls
    ls = "${lib.getExe pkgs.eza}"; # HACK: Bypasses PATH so it works in nix develop shell
    la = "ls --long --no-filesize --no-permissions --no-user --icons --git";
    lat = "la --tree -I .git";
    l = "la --all";
    lt = "l --tree -I .git";
    le = "l --extended";
    lg = "l --git-ignore";
    lgt = "lt --git-ignore";
    ll = "ls --long --all --icons --group";
    llt = "ll --tree -I .git";
    lle = "ll --extended";
    llg = "ll --git-ignore";
    llgt = "llt --git-ignore";

    # erdtree
    erd = "erd --human --hidden --no-git";
    et = "erd";
    tree = "erd --suppress-size --layout inverted --sort name";

    # git
    g = "git";
    gcd = "cd $(git root || echo \".\")";
    ucd = "cd $(uni cd || echo \".\")";

    # grep
    grep = "rg";
    gi = "grep -i";

    # TODO: Investigate psgrep
    psg = "ps x | head -n -2 | gi -e 'PID\\s+TTY\\s+STAT\\s+TIME\\s+COMMAND' -e ";
    psag = "ps ax | head -n -2 | gi -e 'PID\\s+TTY\\s+STAT\\s+TIME\\s+COMMAND' -e ";

    # internet ip
    myip = "echo $(curl -s ipecho.net/plain)";

    # systemd
    ctl = "systemctl";
    stl = "sudo systemctl";
    utl = "systemctl --user";
    ut = "utl start";
    un = "utl stop";
    ur = "utl restart";
    up = "stl start";
    dn = "stl stop";
    rt = "stl restart";
    jtl = "journalctl";

    # Miscellaneous
    mnt = "sudo mount";
    umnt = "sudo umount";
    bmnt = "sudo mnt -o bind,X-mount.mkdir";

    ts = "sudo tailscale";

    dd = "dd status=progress";

    du = "du -h";

    cat = "bat --paging=never";
    catp = "bat --paging=always";

    jh = "cd ~ && j";
    gj = "gcd && j";

    edit = "$EDITOR";
    e = "edit";
    ei = "editi";

    watch = "watch -n 0.5 ";

    lpath = "echo \"$PATH\" | tr \":\" \"\n\"";
    timestamp = "date +%s -d";

    neofetch = "neowofetch";
  };

  home.home.shellAliases = config.environment.shellAliases;

  environment.interactiveShellInit = ''
      if [[ "$(basename "$(readlink "/proc/$PPID/exe")")" == ".kitty-wrapped" ]]; then
        PATH=$(echo "$PATH" | sed 's/\/nix\/store\/[a-zA-Z._0-9+-]\+\/bin:\?//g' | sed 's/:$//')
      fi

      j() {
        if [[ $# -eq 0 ]] then
          \builtin cd -- "$(fd -H -t d | fzf --filepath-word)"
        else
          \builtin cd -- "$(fd -H -t d | fzf --filepath-word -1 -q "$*")"
        fi
      }

    mktmp() {
      if [ "$1" != "" ]; then
        dirspec="$1.XXX"
      else
        dirspec="tmp.XXX"
      fi
      \builtin cd $(mktemp -t -d "$dirspec")
    }

    mktmpunzip() {
      dir=$(mktemp -t -d unzip.XXX)
      if ! file=$(realpath -e "$1"); then
        echo "error: file does not exist"
        return 1
      fi
      shift 1
      unzip "$file" "$@" -d "$dir"
      \builtin cd $dir
      mv $file .
    }

    mktmpclone() {
      location="$1"
      if [ "$2" != "" ]; then
        dirspec="$2.XXX"
        shift 2
      else
        dirspec="clone.XXX"
        shift 1
      fi
      if ! dir=$(mktemp -t -d "$dirspec"); then
        echo "error: couldn't create temp directory"
        return 1
      fi

      git clone "$location" "$dir" "$@"
      \builtin cd "$dir"
    }

    censor-audio() {
      file="$1"
      shift 1

      if [ 2 -gt $# ]; then
        echo "Not enough arguments"
        exit 1
      fi

      filters=""

      while [[ "$1" =~ ^"[0-9]+\.?[0-9]*-[0-9]+\.?[0-9]*"$ ]]; do
        if [ "$filters" != "" ]; then
          filters+=", "
        fi
        filters+="volume=enable='between(t,''${1/-/,})':volume=0"
        shift 1
      done

      ffmpeg -i "$file" -vcodec copy -af "$filters" "$@"
    }

    disget() {
      curl "$1" --output ''${$(basename "$1")%%\?*}
    }
  '';

  environment.variables = {
    FZF_DEFAULT_OPTS = "--extended";
  };

  services.timesyncd.extraConfig = "FallbackNTP=162.159.200.1 2606:4700:f1::1"; # time.cloudflare.com

  security.polkit.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
    cpu.amd.updateMicrocode = true;
  };

  # TODO: Move this somewhere else
  services.minecraft-servers.eula = true;

  home.home.sessionPath = [
    "\${UNIVERSE_FLAKE_ROOT:-/etc/nixos}/bin"
  ];

  networking.hostId = builtins.substring 0 8 (
    builtins.hashString "sha256" config.networking.hostName
  );

  # Disable man cache
  # I don't use it, and it takes ages on rebuild
  documentation.man.generateCaches = lib.mkForce false;
  home-manager.sharedModules = [
    { programs.man.generateCaches = lib.mkForce false; }
  ];
}
