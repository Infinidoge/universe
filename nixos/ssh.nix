{
  lib,
  pkgs,
  common,
  config,
  ...
}:
let
  inherit (config.networking) hostName;

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
        "${name}@${hostName}"
      ];
    };

  sshCAKey = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBlsNWV0I8SR+ITNGmYLRnuNGwX6OBzpBw6kZue5+cRg inx.moe SSH CA
  '';
  sshCAKeyFile = pkgs.writeText "ssh-ca.pub" sshCAKey;
in
{
  imports = [
    {
      options.users.users = lib.mkOption {
        type = with lib.types; attrsOf (submodule userModule);
      };
    }
  ];

  services.openssh = {
    enable = true;
    openFirewall = true;
    sftpServerExecutable = "internal-sftp";
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = lib.mkDefault false;
      GatewayPorts = lib.mkDefault "yes";
      ClientAliveInterval = 60;
      TCPKeepAlive = true;
      TrustedUserCAKeys = "${sshCAKeyFile}";
    };
    hostKeys = lib.mkDefault [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
    extraConfig = lib.mkOrder 1 ''
      HostCertificate /etc/ssh/ssh_host_ed25519_key-cert.pub
    '';

    knownHosts = {
      "inx.moe SSH CA" = {
        hostNames = [ "*" ];
        publicKey = sshCAKey;
        certAuthority = true;
      };

      "github.com" = {
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
        extraHostNames = [
          "ssh.github.com"
          "ssh.github.com:443"
        ];
      };
    };
  };

  environment.etc."ssh/ssh-ca.pub".text = sshCAKey;

  programs.mosh.enable = true;

  programs.ssh = {
    # TODO: Move plug-mirror elsewhere
    extraConfig = ''
      CanonicalizeHostname yes
      CanonicalDomains tailnet.inx.moe

      Host inx.moe
          Port 245

      Host plug-mirror
          Hostname plug-mirror.rcac.purdue.edu
          IdentityAgent none
    '';
  };
}
