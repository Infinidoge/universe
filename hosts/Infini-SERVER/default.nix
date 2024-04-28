{ config, pkgs, lib, private, ... }: {
  imports = [
    private.nixosModules.minecraft-servers
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "22.05";

  info.loc.home = true;

  modules = {
    boot = {
      grub.enable = true;
      timeout = 1;
    };
    hardware = {
      # gpu.nvidia = true;
      form.server = true;
    };
    services.apcupsd = {
      enable = false;
      primary = false;
      config = {
        address = "192.168.1.212";
      };
    };

    backups.extraExcludes = [
      "/srv/minecraft/emd-server/world-backups"
    ];
  };

  services = {
    avahi.reflector = true;

    soft-serve-ng.enable = true;
  };

  services.minecraft-servers.servers.emd-server.autoStart = false;

  services.borgbackup.jobs."persist" = let tmux = lib.getExe pkgs.tmux; in {
    preHook = ''
      ${tmux} -S /run/minecraft/friend-server.sock send-keys "say Server is backing up..." Enter
      ${tmux} -S /run/minecraft/friend-server.sock send-keys save-off Enter
      ${tmux} -S /run/minecraft/friend-server.sock send-keys save-all Enter
    '';
    postHook = ''
      ${tmux} -S /run/minecraft/friend-server.sock send-keys save-on Enter
      ${tmux} -S /run/minecraft/friend-server.sock send-keys "say Backup complete" Enter
    '';
  };

  persist = {
    directories = [
      "/srv"
    ];

    files = [
    ];
  };
}
