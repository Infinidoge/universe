{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.our.flattenListSet {
    suites = with suites; [ base ];
    imports = [ ];
    profiles = with profiles; [
      hardware.gpu.nvidia
    ];
  };

  modules = {
    boot.grub.enable = true;
    hardware.form.server = true;
  };
}
