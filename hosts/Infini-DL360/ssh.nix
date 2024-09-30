{ pkgs, config, ... }:
{
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

  users.users.guest = {
    description = "Guest shell account for temporary access";
    group = "users";
    isNormalUser = true;
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

    Match user guest
      AuthorizedKeysFile /etc/ssh/authorized_keys.d/infinidoge /etc/ssh/authorized_keys.d/%u
      DisableForwarding yes
      PasswordAuthentication no
  '';
}