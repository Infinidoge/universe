{ suites, profiles, pkgs, lib, ... }: {
  imports = lib.lists.flatten [
    (with suites; [
      base
      develop
    ])
  ];

  system.stateVersion = "22.05";

  # I don't use Windows, but when I do, I want NixOS there with me,
  wsl = {
    enable = true;
    automountPath = "/media";
    defaultUser = "infinidoge";
    startMenuLaunchers = true;
  };

  # No host keys -> No decrypted files -> No password files
  modules.secrets.enable = false;

  # This host is only used on WSL on a computer with a strong password already, and agenix is wonky with WSL.
  # Public hash and duplicate password is good enough
  user.hashedPassword = "$6$SDBGTp1hVS7eOs3P$uJwwxOUxrRaMTAPdc349vvSfA7u.4SHtJuXvxxIo4v70WT9KQqmbOOF5qWS9/.okv.HkcBe0CVj5fLaPy9Oew.";
  users.users.root.hashedPassword = "$6$SDBGTp1hVS7eOs3P$uJwwxOUxrRaMTAPdc349vvSfA7u.4SHtJuXvxxIo4v70WT9KQqmbOOF5qWS9/.okv.HkcBe0CVj5fLaPy9Oew.";

  info.model = "Windows Subsystem for Linux";
}
