{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.flatten [
    (with suites; [ base ])
  ];

  modules = {
    boot = {
      grub.enable = true;
      timeout = 1;
    };
    hardware = {
      gpu.nvidia = true;
      form.server = true;
    };
  };
}
