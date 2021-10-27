{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    btrfs-progs
  ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };
}
