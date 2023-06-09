{ suites, profiles, pkgs, lib, private, ... }: {
  imports = lib.our.flattenListSet {
    suites = with suites; [ base develop ];
    imports = [
      ./hardware-configuration.nix
      private.nixosModules.wireless
    ];
  };

  system.stateVersion = "21.11";

  powerManagement.resumeCommands = "${pkgs.kmod}/bin/rmod atkbd; ${pkgs.kmod}/bin/modprobe atkbd reset=1";

  modules = {
    boot = {
      grub.enable = true;
    };
    hardware = {
      form.laptop = true;
      gpu.amdgpu = true;
      wireless.enable = true;
    };
    desktop.wm.enable = true;
  };
}
