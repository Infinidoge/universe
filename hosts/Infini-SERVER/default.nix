{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.our.flattenListSet {
    suites = with suites; [ base ];
    imports = [ ];
    profiles = with profiles; [
      boot.grub

      hardware.gpu.nvidia
    ];
  };

  modules.hardware.form.server = true;
}
