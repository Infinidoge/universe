{ common, ... }:
{
  common.rsyncnet = rec {
    account = "de3418";
    user = "${account}s1";
    host = "${account}.rsync.net";
  };

  programs.ssh.extraConfig = with common.rsyncnet; ''
    Host rsync.net
        Hostname ${host}
        User ${user}

    Host admin.rsync.net
        Hostname ${host}
        User ${account}
  '';
}
