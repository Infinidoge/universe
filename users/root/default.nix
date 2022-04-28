{ lib, config, self, ... }: {
  users.users.root.passwordFile = lib.mkIf config.modules.secrets.enable config.secrets.root-password;

  home-manager.users.root = { suites, profiles, ... }: {
    imports = lib.lists.flatten [
      (with suites; [
        base
      ])
    ];
  };
}
