{ config, self, lib, pkgs, ... }: {
  home-manager.users.infinidoge = { suites, profiles, ... }: {
    imports =
      (with suites; lib.lists.flatten [ base ])
      ++ (with profiles; [ ])
      ++ [ ];
  };

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
