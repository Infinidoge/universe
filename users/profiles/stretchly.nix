{ config, pkgs, ... }: {
  home = {
    packages = with pkgs; [ stretchly ];
    file.stretchly_config = {
      source = ./../infinidoge/config/stretchly.json;
      target = "${config.xdg.configHome}/Stretchly/config.json";
    };
  };
}
