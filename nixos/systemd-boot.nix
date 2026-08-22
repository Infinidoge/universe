{ ... }:
{
  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  # NOTE: systemd-boot stores EVERYTHING in the ESP
  # ESP should be large and mounted on /boot accordingly
  fileSystems."/boot".options = [ "umask=0077" ];
}
