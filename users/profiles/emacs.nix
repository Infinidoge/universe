{ config, pkgs, ... }: {
  services.emacs.enable = true;

  home = {
    sessionPath = [
      "${config.xdg.configHome}/emacs/bin"
    ];

    packages = with pkgs; [
      emacs
      ripgrep
      coreutils
      cmake
      fd
      fzf
      clang
      mu
      isync
      tetex
      jq
      gnumake
      shellcheck
      nodejs
      nodePackages.prettier
      sqlite

      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
    ];
  };
}
