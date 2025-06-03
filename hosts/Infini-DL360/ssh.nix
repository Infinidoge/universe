{ config, pkgs, ... }:
let
  cfg = config.services.openssh;

  neofetchConfig = pkgs.substituteAll {
    src = ./neofetch.conf;

    inherit (config.info) model;
  };
in
{
  users.users = {
    incoming = {
      description = "User for incoming files with a chroot jail";
      isSystemUser = true;
      group = "incoming";
    };

    jump = {
      description = "User for ssh jumping";
      isSystemUser = true;
      group = "nogroup";
    };

    forward = {
      description = "User for ssh forwarding";
      isSystemUser = true;
      group = "nogroup";
    };

    neofetch = {
      description = "SSH Neofetch";
      isSystemUser = true;
      group = "nogroup";
      hashedPassword = "$y$j9T$pixfaOyCz4Sbf8KE8AGVk.$TQKPzMvPan8qrO08kqjuJZO4LlUY7Yjxho0wIbcsmV3"; # :)
      shell = pkgs.bash;
    };

    guest = {
      description = "Guest shell account for temporary access";
      group = "users";
      isNormalUser = true;
      shell = pkgs.bash;
    };
  };
  users.groups = {
    incoming = { };
  };

  security.pam.services.sshd.allowNullPassword = true;

  systemd.tmpfiles.settings."30-external" = {
    "/srv/external".d = {
      user = "root";
      group = "root";
    };
    "/srv/external/incoming".d = {
      user = "incoming";
      group = "incoming";
      mode = "0770";
    };
  };

  environment.systemPackages = with pkgs; [ xorg.xauth ];

  # https://enotacoes.wordpress.com/2021/10/05/limiting-user-to-sshfs-or-sftp-of-one-directory-only/
  # https://github.com/NixOS/nixpkgs/blob/d603719ec6e294f034936c0d0dc06f689d91b6c3/nixos/modules/services/networking/ssh/sshd.nix#L663
  services.openssh.extraConfig = ''
    XAuthLocation ${pkgs.xorg.xauth}/bin/xauth

    Match user infinidoge
      X11Forwarding yes
      X11UseLocalhost no

    Match user incoming
      AuthorizedKeysFile /etc/ssh/authorized_keys.d/infinidoge /etc/ssh/authorized_keys.d/%u
      ChrootDirectory /srv/external
      ForceCommand ${cfg.sftpServerExecutable} -d incoming -u 007
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

    Match user forward
      AuthorizedKeysFile /etc/ssh/authorized_keys.d/infinidoge /etc/ssh/authorized_keys.d/%u
      ForceCommand ${pkgs.shadow}/bin/nologin
      PermitTTY no
      X11Forwarding no
      PermitTunnel yes
      GatewayPorts no
      PasswordAuthentication no

    Match user neofetch
      ForceCommand ${pkgs.hyfetch}/bin/neowofetch --config ${neofetchConfig}
      PermitTTY yes
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
