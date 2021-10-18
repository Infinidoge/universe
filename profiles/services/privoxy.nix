{ ... }: {
  services.privoxy = {
    enable = true;

    settings = {
      enable-edit-actions = true;
      forward-socks5 = "/ 127.0.0.1:1337 .";
    };
  };
}
