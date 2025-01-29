{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.our;
let
  cfg = config.virtualisation;
in
{
  options.virtualisation = {
    enable = mkBoolOpt false;
  };

  config = {
    virtualisation = {
      libvirtd.enable = mkDefault cfg.enable;
      docker.enable = mkDefault cfg.enable;
    };

    programs.dconf.enable = mkIf cfg.libvirtd.enable true;
    environment.systemPackages =
      (optional cfg.libvirtd.enable pkgs.virt-manager)
      ++ (optional cfg.docker.enable pkgs.docker-compose);
    persist.directories = optional cfg.libvirtd.enable "/var/lib/libvirt";
  };
}
