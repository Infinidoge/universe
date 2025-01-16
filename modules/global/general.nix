{ config, common, secrets, lib, ... }:
{
  programs = {
    # Enable dconf for programs that need it
    dconf.enable = true;

    udevil.enable = true;
  };

  wsl.defaultUser = config.user.name;

  services = {
    # Enable Early Out of Memory service
    earlyoom.enable = true;

    # Accept EULA for all minecraft servers
    minecraft-servers.eula = true;
  };

  # Ensure certain necessary directories always exist
  systemd.tmpfiles.rules = [
    "d /mnt 0777 root root - -"
  ];

  services.timesyncd.extraConfig = "FallbackNTP=162.159.200.1 2606:4700:f1::1"; # time.cloudflare.com

  # Reenable when CI and a binary cache is setup
  #environment.noXlibs = lib.mkDefault (!config.info.graphical);

  persist.hideMounts = true;

  # Disable force importing ZFS roots
  boot.zfs.forceImportRoot = false;

  # Disable man cache
  # I don't use it, and it takes ages on rebuild
  documentation.man.generateCaches = lib.mkForce false;
  home-manager.sharedModules = [
    { programs.man.generateCaches = lib.mkForce false; }
  ];

  programs.msmtp = with common.email; {
    enable = true;
    setSendmail = true;
    defaults = {
      host = smtp.address;
      port = smtp.STARTTLS;
      tls = true;
      auth = true;
    };
    accounts = rec {
      noreply = {
        user = outgoing;
        passwordeval = "cat ${secrets.smtp-password}";
      };
      default = noreply // {
        from = withSubaddress "%U-%H";
      };
    };
  };
}
