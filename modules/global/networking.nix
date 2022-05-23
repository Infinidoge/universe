{ pkgs, ... }:
{
  networking = {
    useDHCP = false;
    firewall.checkReversePath = "loose";
  };

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        userServices = true;
      };
      extraServiceFiles = {
        ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
      };
    };

    tailscale.enable = true;
  };
}
