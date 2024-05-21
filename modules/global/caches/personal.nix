{ config, lib, ... }:
{
  nix.settings = {
    substituters = lib.flatten [
      (lib.optional (config.networking.hostName != "Infini-DESKTOP" && config.info.loc.home) "ssh://infini-desktop")
      "https://hydra.inx.moe"
    ];
    trusted-public-keys = [
      "infinidoge-1:uw2A6JHHdGJ9GPk0NEDnrdfVkPp0CUY3zIvwVgNlrSk="
    ];
  };
}
