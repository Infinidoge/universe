{ lib, ... }: {
  users.users.root.hashedPassword =
    "PASSWORD SET IN THE FUTURE";

  home-manager.users.root = { suites, profiles, ... }: {
    imports = lib.lists.flatten [
      (with suites; [
        base
      ])
    ];
  };
}
