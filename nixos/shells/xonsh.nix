{ config, pkgs, ... }:
let
  cfg = config.programs.xonsh;
  inherit (cfg.package) xontribs;
in
{
  programs.xonsh = {
    enable = true;
    extraPackages =
      p: with p; [
        parallel-ssh
        xontribs.xonsh-direnv
        requests
      ];
    config = ''
      xontrib load direnv
      execx($(zoxide init xonsh --cmd cd), 'exec', __xonsh__.ctx, filename='zoxide')

      if $TERM != "dumb": execx($(starship init xonsh))
    '';
  };
}
