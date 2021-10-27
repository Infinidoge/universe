{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    btrfs-progs
  ];

  srvices.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };
}
