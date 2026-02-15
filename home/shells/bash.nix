{ config, lib, ... }:
{
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    initExtra = ''
      source <(${lib.getExe config.programs.kitty.package} + complete setup bash)
    '';
  };
}
