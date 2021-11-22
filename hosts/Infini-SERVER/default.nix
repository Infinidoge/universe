{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.our.flattenListSet {
    suites = with suites; [ base ];
  };

  modules = {
    boot.grub.enable = true;
    hardware = {
      gpu.nvidia = true;
      form.server = true;
    };
  };
}
