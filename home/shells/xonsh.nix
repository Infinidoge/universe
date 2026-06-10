{
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
  # BUG: https://github.com/prompt-toolkit/python-prompt-toolkit/issues/1933
  programs.xonsh = {
    enable = true;
    package = lib.hiPrio (pkgs.xonsh.override { python3 = pkgs.python314; });
    extraPackages =
      p: with p; [
        xontribs.xonsh-direnv

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
      execx($(zoxide init xonsh --cmd cd --hook pwd), 'exec', __xonsh__.ctx, filename='zoxide')

      @.imp.os.sys.path.append(".") # add current directory to import path

      if $TERM != "dumb": execx($(starship init xonsh))
    '';
    shellAliases = {
      ucd = ''cd @($(@error_ignore universe-cli cd) or ".")'';
      gcd = ''cd @($(@error_ignore git root) or ".")'';
    };
  };

  # TODO: symlink ./xonshrc to ~/.config/xonsh/rc.d
}
