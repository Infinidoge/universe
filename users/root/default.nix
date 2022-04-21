{ lib, config, self, ... }: {
  age.secrets.root-password.file = "${self}/secrets/root-password.age";

  users.users.root.passwordFile = config.age.secrets.root-password.path;

  home-manager.users.root = { suites, profiles, ... }: {
    imports = lib.lists.flatten [
      (with suites; [
        base
      ])
    ];
  };
}
