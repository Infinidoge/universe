{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    btrfs-progs
  ];

  services.btrfs.autoScrub = {
    enable = lib.mkDefault true;
    interval = "monthly";
  };
}
