{ config, lib, ... }:
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

  system.activationScripts = {
    # FIX: command-not-found database doesn't exist normally
    # FIXME: activation script doesn't work properly, and frequently errors
    # channels-update.text = "${pkgs.nix}/bin/nix-channel --update";
  };
}
