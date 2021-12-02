{ config, options, lib, pkgs, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.modules.filesystems.btrfs;
  opt = options.modules.filesystems.btrfs;
in
{
  options.modules.filesystems.btrfs = with types; {
    enable = mkBoolOpt false;
    scrub = mkOpt attrs { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      btrfs-progs
    ];

    services.btrfs.autoScrub = mkAliasDefinitions opt.scrub;
  };
}
