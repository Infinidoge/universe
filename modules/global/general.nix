{ pkgs, ... }:
{
  bud.enable = true;

  programs = {
    # Enable dconf for programs that need it
    dconf.enable = true;

    udevil.enable = true;
  };

  services = {
    # Enable Early Out of Memory service
    earlyoom.enable = true;

    # Ensure certain necessary directories always exist
    ensure.directories = [ "/mnt" ];

    # Accept EULA for all minecraft servers
    minecraft-servers.eula = true;
  };

  system.activationScripts = {
    # FIX: command-not-found database doesn't exist normally
    channels-update.text = "${pkgs.nix}/bin/nix-channel --update";
  };
}
