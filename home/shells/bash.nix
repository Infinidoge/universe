{ config, lib, ... }:
{
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    initExtra = ''
      if which kitty; then
        source <(kitty + complete setup bash)
      fi
    '';
  };
}
