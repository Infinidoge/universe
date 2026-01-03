{
  common,
  lib,
  config,
  ...
}:
let
  top = config;

  userModule =
    {
      name,
      config,
      options,
      ...
    }:
    {
      openssh.authorizedPrincipals = lib.mkIf (config.shell != options.shell.default) [
        name
        "${name}@${top.networking.hostName}"
      ];
    };

in
with lib;
{
  imports = [
    {
      options.users.users = lib.mkOption {
        type = with lib.types; attrsOf (submodule userModule);
      };
    }
  ];

  # For rage encryption, all hosts need a ssh key pair
  services.openssh = {
    enable = true;
    openFirewall = mkDefault true;
    sftpServerExecutable = "internal-sftp";
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = mkDefault false;
      GatewayPorts = mkDefault "yes";
      ClientAliveInterval = 60;
      TCPKeepAlive = "yes";
      TrustedUserCAKeys = "${./ssh-ca.pub}";
    };
    hostKeys = mkDefault [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
    extraConfig = lib.mkOrder 1 ''
      HostCertificate /etc/ssh/ssh_host_ed25519_key-cert.pub
    '';
    knownHosts = {
      "github.com" = {
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
        extraHostNames = [
          "ssh.github.com"
          "ssh.github.com:443"
        ];
      };
      "inx.moe SSH CA" = {
        hostNames = [ "*" ];
        publicKeyFile = ./ssh-ca.pub;
        certAuthority = true;
      };
    };
  };

  environment.etc."ssh/ssh-ca.pub".source = ./ssh-ca.pub;

  programs.ssh = {
    extraConfig = with common; ''
      CanonicalizeHostname yes
      CanonicalDomains tailnet.inx.moe

      Host rsync.net
          Hostname ${rsyncnet.host}
          User ${rsyncnet.user}

      Host admin.rsync.net
          Hostname ${rsyncnet.host}
          User ${rsyncnet.account}

      Host inx.moe
          Port 245

      Host plug-mirror
          Hostname plug-mirror.rcac.purdue.edu
          IdentityAgent none
    '';
  };

  programs.mosh.enable = true;
}
