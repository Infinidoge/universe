{ config, lib, ... }:
let
  ifSudo = lib.mkIf config.security.sudo.enable;
in
{
  environment.shellAliases = {
    # quick cd
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    # git
    g = "git";

    gcd = "cd $(git root)";

    # grep
    grep = "rg";
    gi = "grep -i";

    # internet ip
    myip = "curl ipecho.net/plain";

    # sudo
    s = ifSudo "sudo -E ";
    si = ifSudo "sudo -i";
    se = ifSudo "sudoedit";

    # systemd
    ctl = "systemctl";
    stl = ifSudo "s systemctl";
    utl = "systemctl --user";
    ut = "systemctl --user start";
    un = "systemctl --user stop";
    up = ifSudo "s systemctl start";
    dn = ifSudo "s systemctl stop";
    jtl = "journalctl";

    ll = "ls -al";
    dd = "dd status=progress";
    cat = "bat --paging=never";

    lsdisk = "lsblk -o name,size,mountpoints,fstype,label,uuid,fsavail,fsuse%";

    mnt = "s mount";
    umnt = "s umount";

    mktmp = "cd $(mktemp -d)";

    edit = "$EDITOR";

    path = "tr ':' '\n' <<< \"$PATH\"";
  };
}
