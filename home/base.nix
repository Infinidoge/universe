{ lib, pkgs, ... }:
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

  shellInit = ''
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
in
{
  home.packages = with pkgs; [
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

    # misc
    htop
    hyfetch
    unzip
    zip

    # custom
    universe-cli
    editi
  ];

  home.shellAliases = {
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

  home.sessionPath = [
    "\${UNIVERSE_FLAKE_ROOT:-/etc/nixos}/bin"
  ];

  programs.bash.initExtra = shellInit;
  programs.zsh.initContent = shellInit;

  home.sessionVariables = {
    FZF_DEFAULT_OPTS = "--extended";
  };
}
