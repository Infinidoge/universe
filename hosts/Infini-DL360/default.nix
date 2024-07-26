{ config, lib, pkgs, private, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix

    ./web.nix

    private.nixosModules.minecraft-servers
    ./conduwuit.nix
    ./factorio.nix
    ./forgejo.nix
    ./freshrss.nix
    ./hydra.nix
    ./jellyfin.nix
    ./jitsi.nix
    ./postgresql.nix
    ./thelounge.nix
    ./vaultwarden.nix
  ];

  networking.hostId = "8fa7a57c";
  system.stateVersion = "23.11";

  info.loc.purdue = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  nix.distributedBuilds = false;

  modules = {
    hardware.form.server = true;
  };

  boot.loader.timeout = 5;

  virtualisation.enable = true;

  persist = {
    directories = [
      "/srv"

      # TODO: Setup in module
      "/var/lib/acme"
    ];
    files = [
    ];
  };

  documentation.man.man-db.enable = false;

  networking = {
    firewall = {
      allowedUDPPorts = [ 80 443 ];
      allowedTCPPorts = [ 80 443 25565 ];
    };
  };

  hardware.infiniband = {
    enable = true;
  };

  services.fail2ban.enable = true;

  environment.etc."fail2ban/filter.d/nginx-url-probe.local".text = lib.mkDefault (lib.mkAfter ''
    [Definition]
    failregex = ^<HOST>.*(GET /(wp-|admin|boaform|phpmyadmin|\.env|\.git|notifications)|\.(dll|so|cfm|asp)|(\?|&)(=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000|=PHPE9568F36-D428-11d2-A769-00AA001ACF42|=PHPE9568F35-D428-11d2-A769-00AA001ACF42|=PHPE9568F34-D428-11d2-A769-00AA001ACF42)|\\x[0-9a-zA-Z]{2})
  '');

  services.fail2ban.jails.nginx-url-probe.settings = {
    enabled = true;
    filter = "nginx-url-probe";
    logpath = "/var/log/nginx/access.log";
    action = "%(action_)s[blocktype=DROP]";
    backend = "auto";
    maxretry = 5;
    findtime = 600;
  };

  services.nginx.enable = true;

  modules.backups.excludes = {
    "/var/log/" = [
      "nginx/access.log"
    ];
  };

  security.acme.certs."inx.moe" = {
    group = "nginx";
    extraDomainNames = [ "*.inx.moe" ];
  };

  services.nginx.virtualHosts."*.inx.moe" = {
    useACMEHost = "inx.moe";
    addSSL = true;
    default = true;
    globalRedirect = "inx.moe";
    redirectCode = 302;
  };

  services.minecraft-servers.servers.emd-server.autoStart = lib.mkForce false;

  services.borgbackup.jobs."persist" = let tmux = lib.getExe pkgs.tmux; in {
    preHook = ''
      ${tmux} -S /run/minecraft/friend-server.sock send-keys "say Server is backing up..." Enter
      ${tmux} -S /run/minecraft/friend-server.sock send-keys save-off Enter
      ${tmux} -S /run/minecraft/friend-server.sock send-keys save-all Enter
      ${tmux} -S /run/minecraft/sister-server.sock send-keys "say Server is backing up..." Enter
      ${tmux} -S /run/minecraft/sister-server.sock send-keys save-off Enter
      ${tmux} -S /run/minecraft/sister-server.sock send-keys save-all Enter
    '';
    postHook = ''
      ${tmux} -S /run/minecraft/friend-server.sock send-keys save-on Enter
      ${tmux} -S /run/minecraft/friend-server.sock send-keys "say Backup complete" Enter
      ${tmux} -S /run/minecraft/sister-server.sock send-keys save-on Enter
      ${tmux} -S /run/minecraft/sister-server.sock send-keys "say Backup complete" Enter
    '';
  };

  users.users.incoming = {
    description = "User for incoming files with a chroot jail";
    isSystemUser = true;
    group = "incoming";
  };
  users.groups.incoming = { };

  users.users.jump = {
    description = "User for ssh jumping";
    isSystemUser = true;
    group = "nogroup";
  };

  users.users.neofetch = {
    description = "SSH Neofetch";
    isSystemUser = true;
    group = "nogroup";
    hashedPassword = "$y$j9T$pixfaOyCz4Sbf8KE8AGVk.$TQKPzMvPan8qrO08kqjuJZO4LlUY7Yjxho0wIbcsmV3"; # :)
    shell = pkgs.bash;
  };

  security.pam.services.sshd.allowNullPassword = true;

  systemd.tmpfiles.settings."30-external" = {
    "/srv/external".d = { user = "root"; group = "root"; };
    "/srv/external/incoming".d = { user = "incoming"; group = "incoming"; mode = "0770"; };
  };

  # https://enotacoes.wordpress.com/2021/10/05/limiting-user-to-sshfs-or-sftp-of-one-directory-only/
  # https://github.com/NixOS/nixpkgs/blob/d603719ec6e294f034936c0d0dc06f689d91b6c3/nixos/modules/services/networking/ssh/sshd.nix#L663
  services.openssh.extraConfig = ''
    Match user incoming
      AuthorizedKeysFile /etc/ssh/authorized_keys.d/infinidoge /etc/ssh/authorized_keys.d/%u
      ChrootDirectory /srv/external
      ForceCommand ${config.services.openssh.sftpServerExecutable} -d incoming -u 007
      X11Forwarding no
      AllowTcpForwarding no
      KbdInteractiveAuthentication no
      PasswordAuthentication no

    Match user jump
      AuthorizedKeysFile /etc/ssh/authorized_keys.d/infinidoge /etc/ssh/authorized_keys.d/%u
      ForceCommand ${pkgs.shadow}/bin/nologin
      PermitTTY no
      X11Forwarding no
      PermitTunnel no
      GatewayPorts no
      PasswordAuthentication no

    Match user neofetch
      ForceCommand ${pkgs.hyfetch}/bin/neowofetch --config ${config.home-manager.users.infinidoge.xdg.configFile."neofetch/config.conf".source} --backend ascii
      PermitTTY no
      DisableForwarding yes
      AuthenticationMethods none
      KbdInteractiveAuthentication yes
      PermitEmptyPasswords yes
  '';
}
