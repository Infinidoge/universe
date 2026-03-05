{ config, pkgs, ... }:
let
  cfg = config.programs.xonsh;
  inherit (cfg.package) xontribs;
in
{
  # BUG: https://github.com/prompt-toolkit/python-prompt-toolkit/issues/1933
  programs.xonsh = {
    enable = true;
    extraPackages =
      p: with p; [
        xontribs.xonsh-direnv

        parallel-ssh
        requests
      ];
    config = ''
      xontrib load direnv
      execx($(zoxide init xonsh --cmd cd), 'exec', __xonsh__.ctx, filename='zoxide')

      if $TERM != "dumb": execx($(starship init xonsh))
    '';
  };
}
