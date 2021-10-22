{ pkgs, lib, budUtils, ... }: {
  bud.cmds = with pkgs; {
    get = {
      writer = budUtils.writeBashWithPaths [ nixUnstable git coreutils ];
      synopsis = "get [DEST]";
      help = "Copy the desired template to DEST";
      script = ./get.bash;
    };

    buildthis = {
      writer = budUtils.writeBashWithPaths [ nixUnstable nixos-rebuild git coreutils mercurial ];
      synopsis = "buildthis (switch|boot|test)";
      help = "Shortcut for nixos-rebuild using the current hostname";
      script = ./buildthis.bash;
    };

    install-doom = {
      writer = budUtils.writeBashWithPaths [ git coreutils emacs ];
      synopsis = "install-doom [ARGS]";
      help = "Installs Doom Emacs from https://github.com/hlissner/doom-emacs";
      script = ./install-doom.bash;
    };
  };
}
