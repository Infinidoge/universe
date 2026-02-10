{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.home.packages = with pkgs; [
    # minecraft
    prismlauncher
    unbted
    alsa-oss
    packwiz

    # puzzles
    sgt-puzzles

    # steam
    protonup-ng
    wineWowPackages.stable
  ];

  home.home.sessionVariables.UNISON = "$HOME/.local/state/unison";

  home.services.unison = {
    enable = true;
    pairs = {
      "PrismLauncher" = lib.mkIf (config.networking.hostName != "daedalus") {
        roots = [
          "/home/infinidoge/.local/share/PrismLauncher"
          "ssh://inx.moe/sync/PrismLauncher"
        ];
        commandOptions = {
          ignore = [
            "BelowPath cache"
            "BelowPath logs"
            "BelowPath **/logs"
            "Path **/*.log"
            "BelowPath meta"
            "Path metacache"
          ];
          sshargs = [
            "-o ControlMaster=no"
          ];
        };
      };
    };
  };

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
