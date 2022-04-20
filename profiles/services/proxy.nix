{ ... }:
let
  listen-address = "localhost:8118";
in
{
  services = {
    privoxy = {
      enable = true;

      settings = {
        inherit listen-address;
        enable-edit-actions = true;
        forward-socks5 = "/ 127.0.0.1:49494 .";
      };
    };

    ssh-tunnel = {
      enable = true;
      server = "infinidoge@server.doge-inc.net -p 245 -S none -i /home/infinidoge/.ssh/id_ed25519 -v";
      # server = "infinidoge@71.90.199.237 -p 245 -S none -i /home/infinidoge/.ssh/id_ed25519 -v";
      requiredBy = [ "privoxy.service" ];
      forwards.dynamic = [ 49494 ];
    };
  };

  networking.proxy.default = listen-address;
}
