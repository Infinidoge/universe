{ config, self, lib, pkgs, ... }: {
  home-manager.users.infinidoge = { suites, ... }: {
    imports = suites.base;
  };

  environment.pathsToLink = [ "/share/zsh" ];

  users.users.infinidoge = {
    uid = 1000;
    hashedPassword =
      "PASSWORD SET IN THE FUTURE";
    description = "Infinidoge";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
}
