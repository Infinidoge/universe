{
  config,
  lib,
  pkgs,
  ...
}:
let
  ifSudo = lib.mkIf config.security.sudo.enable;
  ifSudo' = text: if config.security.sudo.enable then "sudo ${text}" else text;
in
{
  programs = {
    fish.enable = true;
    zsh.enable = true;
  };

  universe.shellAliases = {
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
    stl = ifSudo' "systemctl";
    utl = "systemctl --user";
    ut = "utl start";
    un = "utl stop";
    ur = "utl restart";
    up = "stl start";
    dn = "stl stop";
    rt = "stl restart";
    jtl = "journalctl";

    # Miscellaneous
    mnt = ifSudo' "mount";
    umnt = ifSudo' "umount";
    bmnt = ifSudo "mnt -o bind,X-mount.mkdir";

    ts = ifSudo' "tailscale";

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

  universe.packages = [
    (pkgs.writeScriptBin "editi" ''
      if [[ $# -eq 0 ]] then
        fd -H -t f | fzf --filepath-word --multi | xargs $EDITOR
      else
        fd -H -t f | fzf --filepath-word --multi -1 -q "$*" | xargs $EDITOR
      fi
    '')
  ];

  universe.variables = {
    FZF_DEFAULT_OPTS = "--extended";
  };

  environment.variables = config.universe.variables;

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

    disgetconv() {
      url="$1"
      tmpFileName="''${$(basename "$url")%%\?*}.XXX"
      tmpFile=$(mktemp -t $tmpFileName)
      curl "$url" --output "$tmpFile"
      shift 1
      magick "$tmpFile" "$@"
    }

    disgetconvv() {
      url="$1"
      tmpFileName="''${$(basename "$url")%%\?*}.XXX"
      tmpFile=$(mktemp -t $tmpFileName)
      curl "$url" --output "$tmpFile"
      shift 1
      ffmpeg -i "$tmpFile" "$@"
    }
  '';

  environment.shellAliases = config.universe.shellAliases // {
    # sudo
    sudo = ifSudo "sudo -E ";
    s = ifSudo "sudo ";
    si = ifSudo "sudo -i";
    se = ifSudo "sudoedit";

    # Miscellaneous
    acat = "mpv --no-audio-display";
    vcat = "mpv";

    lsdisk = "lsblk -o name,size,mountpoints,fstype,label,fsavail,fsuse%";
    lsdisks = "lsblk -o name,size,fstype,label,uuid,fsavail,fsuse%";

    # yt-dlp
    yt-m4a = ''yt-dlp -f "bestaudio[ext=m4a]" -o "%(title)s.%(ext)s"'';
    yt-mp4 = ''yt-dlp -f "best[ext=mp4]" -o "%(title)s.%(ext)s"'';
  };
}
