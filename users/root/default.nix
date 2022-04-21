{ lib, config, self, ... }: {
  users.users.root.passwordFile = config.secrets.root-password;

  home-manager.users.root = { suites, profiles, ... }: {
    imports = lib.lists.flatten [
      (with suites; [
        base
      ])
    ];
  };
}
