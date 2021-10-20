{ pkgs, ... }: {
  services = {
    privoxy = {
      enable = true;

      settings = {
        enable-edit-actions = true;
        forward-socks5 = "/ 127.0.0.1:1337 .";
        listen-address = "localhost:8118";
      };
    };

    ssh-tunnel = {
      enable = true;
      server = "infinidoge@server.doge-inc.net -p 245 -i /home/infinidoge/.ssh/id_ed25519";
      requiredBy = [ "privoxy.service" ];
      forwards.dynamic = [ 1337 ];
    };
  };
}
