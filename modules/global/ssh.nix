{ config, lib, ... }:
with lib;
{
  # For rage encryption, all hosts need a ssh key pair
  services.openssh = {
    enable = true;
    openFirewall = mkDefault true;
    sftpServerExecutable = "internal-sftp";
    settings = {
      X11Forwarding = mkDefault false;
      GatewayPorts = mkDefault "yes";
    };
    hostKeys = mkDefault [{
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  programs.ssh = {
    extraConfig = with config.common; ''
      Host rsync.net
          Hostname ${rsyncnet.host}
          User ${rsyncnet.user}

      Host admin.rsync.net
          Hostname ${rsyncnet.host}
          User ${rsyncnet.account}

      Host inx.moe
          Port 245

      Host vulcan
          Hostname vulcan.tail4d9247.ts.net
    '';
  };

  programs.mosh.enable = true;
}
