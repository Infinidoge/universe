{ pkgs, lib, budUtils, ... }: {
  bud.cmds = with pkgs; {
    up.enable = false;

    b = {
      writer = budUtils.writeBashWithPaths [ nixUnstable nixos-rebuild git coreutils mercurial ];
      synopsis = "b (switch|boot|test)";
      help = "Shortcut for nixos-rebuild using the current hostname";
      script = ./b.bash;
    };

    gc = {
      writer = budUtils.writeBashWithPaths [ nixUnstable ];
      synopsis = "gc [-d]";
      help = "Shortcut for nix-collect-garbage for both the user and root";
      script = ./gc.bash;
    };

    install-doom = {
      writer = budUtils.writeBashWithPaths [ git coreutils emacs ];
      synopsis = "install-doom [ARGS]";
      help = "Installs Doom Emacs from https://github.com/hlissner/doom-emacs";
      script = ./install-doom.bash;
    };
  };
}
