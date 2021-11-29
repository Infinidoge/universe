{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.our.flattenListSet {
    suites = with suites; [ graphic develop ];
    imports = [ ./hardware-configuration.nix ];
    profiles = with profiles;
      [
        networking.wireless

        btrfs

        # services.privoxy
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
  };

  networking.interfaces.wlan0.useDHCP = true;
}
