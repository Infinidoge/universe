{ config, options, lib, pkgs, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.modules.filesystems;
  opt = options.modules.filesystems;
in
{
  options.modules.filesystems = {
    enable = mkBoolOpt false;

    btrfs = with types; {
      enable = mkBoolOpt false;
      scrub = mkOpt attrs { };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      programs.udevil.enable = true;

      environment.systemPackages = with pkgs; [
        sshfs
        exfat # Windows drives
        ntfs3g # Windows drives
      ];
    })

    (mkIf cfg.btrfs.enable {
      environment.systemPackages = with pkgs; [ btrfs-progs ];

      services.btrfs.autoScrub = mkAliasDefinitions opt.btrfs.scrub;
    })
  ];
}
