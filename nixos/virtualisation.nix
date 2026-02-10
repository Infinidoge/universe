{ pkgs, ... }:
{
  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
  };

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
    docker-compose
  ];

  persist.directories = [
    "/var/lib/libvirt"
  ];
}
