{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "22.05";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8ptHWTesaUzglq01O8OVqeAGxFhXutUZpkgPpBFqzY root@Infini-SERVER";

  info.loc.home = true;

  modules.hardware.form.server = true;

  boot.loader.timeout = 1;

  persist.directories = [
    "/srv"
  ];
}
