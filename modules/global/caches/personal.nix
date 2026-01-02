{ config, lib, ... }:
let
  inherit (lib) optional;
  inherit (config.networking) hostName;
  inherit (config.info.loc) home;
in
{
  nix.settings = {
    substituters = lib.flatten [
      (optional (hostName != "apophis" && home) "ssh-ng://apophis?priority=9")
      (optional (hostName != "Infini-DL360") "https://hydra.inx.moe?priority=10")
    ];
    trusted-public-keys = [
      "infinidoge-1:uw2A6JHHdGJ9GPk0NEDnrdfVkPp0CUY3zIvwVgNlrSk="
    ];
  };
}
