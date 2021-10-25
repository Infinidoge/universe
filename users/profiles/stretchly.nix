{ config, pkgs, ... }: {
  home.packages = with pkgs; [ stretchly ];

  xdg.configFile."Stretchly/config.json".source =
    ./../infinidoge/config/stretchly.json;
}
