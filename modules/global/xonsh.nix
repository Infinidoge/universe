{ config, pkgs, ... }:
let
  cfg = config.programs.xonsh;
in
{
  programs.xonsh = {
    enable = true;
    extraPackages =
      p: with p; [
        parallel-ssh
        cfg.package.xontribs.xonsh-direnv
      ];
    config = ''
      xontrib load direnv

      if $TERM != "dumb":
          execx($(starship init xonsh))
    '';
  };
}
