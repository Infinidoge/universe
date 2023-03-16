{ config, lib, ... }:
let
  ifSudo = lib.mkIf config.security.sudo.enable;
in
{
  environment.shellAliases = {
    # quick cd
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    # ls
    ls = "exa";
    la = "ls --long --no-filesize --no-permissions --no-user --git --icons";
    lat = "la --tree";
    l = "la --all";
    lt = "l --tree";
    le = "l --extended";
    lg = "l --git-ignore";
    lgt = "lt --git-ignore";
    ll = "ls --long --all --group --icons";
    llt = "ll --tree";
    lle = "ll --extended";
    llg = "ll --git-ignore";
    llgt = "llt --git-ignore";

    # git
    g = "git";

    gcd = "cd $(git root || echo \".\")";

    # grep
    grep = "rg";
    gi = "grep -i";

    # TODO: Investigate psgrep
    psg = "ps x | head -n -2 | gi -e 'PID\\s+TTY\\s+STAT\\s+TIME\\s+COMMAND' -e ";
    psag = "ps ax | head -n -2 | gi -e 'PID\\s+TTY\\s+STAT\\s+TIME\\s+COMMAND' -e ";

    # internet ip
    myip = "echo $(curl -s ipecho.net/plain)";

    # sudo
    s = ifSudo "sudo -E ";
    si = ifSudo "sudo -i";
    se = ifSudo "sudoedit";

    # systemd
    ctl = "systemctl";
    stl = ifSudo "s systemctl";
    utl = "systemctl --user";
    ut = "utl start";
    un = "utl stop";
    ur = "utl restart";
    up = ifSudo "stl start";
    dn = ifSudo "stl stop";
    rt = ifSudo "stl restart";
    jtl = "journalctl";

    # Miscellaneous
    dd = "dd status=progress";
    cat = "bat --paging=never";
    catp = "bat --paging=always";

    lsdisk = "lsblk -o name,size,mountpoints,fstype,label,uuid,fsavail,fsuse%";

    mnt = "s mount";
    umnt = "s umount";

    mktmp = "cd $(mktemp -d)";

    edit = "$EDITOR";

    path = "tr ':' '\n' <<< \"$PATH\"";
    timestamp = "date +%s -d";
  };
}
