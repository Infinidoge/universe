{ config, lib, ... }:
{
  nix.settings = {
    substituters = lib.mkIf (config.networking.hostName != "Infini-DESKTOP" && config.info.loc.home)
      ((if config.info.loc.home then (lib.mkOrder 300) else lib.mkAfter) [
        "ssh://infini-desktop"
      ]);
    trusted-public-keys = [
      "infinidoge-1:uw2A6JHHdGJ9GPk0NEDnrdfVkPp0CUY3zIvwVgNlrSk="
    ];
  };
}
