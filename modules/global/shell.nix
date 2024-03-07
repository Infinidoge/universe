{ config, lib, pkgs, ... }:
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
    la = "ls --long --no-filesize --no-permissions --no-user --git --icons";
    lat = "la --tree -I .git";
    l = "la --all";
    lt = "l --tree -I .git";
    le = "l --extended";
    lg = "l --git-ignore";
    lgt = "lt --git-ignore";
    ll = "ls --long --all --group --icons";
    llt = "ll --tree -I .git";
    lle = "ll --extended";
    llg = "ll --git-ignore";
    llgt = "llt --git-ignore";

    # erdtree
    et = "erd";

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

    dd = "dd status=progress";

    cat = "bat --paging=never";
    catp = "bat --paging=always";

    mktmp = "cd $(mktemp -d)";

    edit = "$EDITOR";

    lpath = "echo \"$PATH\" | tr \":\" \"\n\"";
    timestamp = "date +%s -d";

    neofetch = "neowofetch";
  };

  universe.variables = {
  };

  environment.variables = config.universe.variables;

  environment.shellAliases = config.universe.shellAliases // {
    # sudo
    s = ifSudo "sudo -E ";
    si = ifSudo "sudo -i";
    se = ifSudo "sudoedit";

    # Miscellaneous
    acat = "mpv --no-audio-display";
    vcat = "mpv";

    lsdisk = "lsblk -o name,size,mountpoints,fstype,label,uuid,fsavail,fsuse%";
    lsdiskw = "while true; do clear; lsdisk; sleep 1; done";

    # yt-dlp
    yt-m4a = ''yt-dlp -f "bestaudio[ext=m4a]" -o "%(title)s.%(ext)s"'';
    yt-mp4 = ''yt-dlp -f "best[ext=mp4]" -o "%(title)s.%(ext)s"'';
  };
}
