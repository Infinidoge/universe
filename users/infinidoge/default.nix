{ hmUsers, ... }: {
  home-manager.users = { inherit (hmUsers) infinidoge; };

  users.users.infinidoge = {
    uid = 1000;
    hashedPassword =
      "PASSWORD SET IN THE FUTURE";
    description = "Infinidoge";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
