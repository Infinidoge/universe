{ config, self, lib, pkgs, ... }: {
  home-manager.users.infinidoge = { suites, ... }: {
    imports = suites.base;
  };

  users.users.infinidoge = {
    uid = 1000;
    hashedPassword =
      "PASSWORD SET IN THE FUTURE";
    description = "Infinidoge";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
