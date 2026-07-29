{
  self,
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.xonsh;
  inherit (cfg.package) xontribs;
in
{
  imports = [
    self.vendored.home.xonsh
  ];

  # BUG: https://github.com/prompt-toolkit/python-prompt-toolkit/issues/1933
  programs.xonsh = {
    enable = true;
    package = lib.hiPrio (pkgs.xonsh.override { python3 = pkgs.python314; });
    extraPackages =
      p: with p; [
        xontribs.xonsh-direnv
        #xontribs.xontrib-jedi
        #xontribs.xontrib-fish-completer
        # xontrib-uvox (https://codeberg.org/mgrobol/xontrib-uvox)
        # xontrib-term-integrations (https://github.com/jnoortheen/xontrib-term-integrations)
        # xontrib-mpl (https://github.com/xonsh/xontrib-mpl)

        beautifulsoup4
        dnspython
        parallel-ssh
        python-dateutil
        requests
        soupsieve
        tqdm
      ];
    xonshrc = ''
      xontrib load direnv
      #xontrib load jedi
      #xontrib load fish_completer

      execx($(zoxide init xonsh --cmd cd --hook pwd), 'exec', __xonsh__.ctx, filename='zoxide')

      @.imp.sys.path.append(".") # add current directory to import path

      if $TERM != "dumb": execx($(starship init xonsh))
    '';
    shellAliases = {
      ucd = ''cd @($(@error_ignore universe-cli cd) or ".")'';
      gcd = ''cd @($(@error_ignore git root) or ".")'';
    };
  };

  # TODO: symlink ./xonshrc to ~/.config/xonsh/rc.d
}
