{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "23.05";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG8fY684SPKeOUsJqaV6LJwwztWxztaU9nAHPBxBtyU root@dionysus";

  info.loc.purdue = true;

  boot.loader.timeout = 1;

  modules = {
    hardware.form.desktop = true;
    hardware.gpu.intel = true;
    desktop.wm.enable = true;
  };

  services.printing = {
    enable = true;
    listenAddresses = [
      "localhost:631"
      "100.101.102.18:631"
      "dionysus:631"
    ];
    allowFrom = [ "all" ];
    defaultShared = true;
    openFirewall = true;
  };

  services.httpd = {
    enable = true;
    virtualHosts."dionysus.tailnet.inx.moe" = rec {
      documentRoot = "/srv/seppo";
      extraConfig = ''
        AddHandler cgi-script .cgi

        <Directory "${documentRoot}">
            AllowOverride All
            Options All
            Require all granted
        </Directory>
      '';
    };
  };
}
