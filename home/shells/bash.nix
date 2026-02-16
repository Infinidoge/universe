{ config, lib, ... }:
{
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    initExtra = ''
      if which kitty > /dev/null; then
        source <(kitty + complete setup bash)
      fi
    '';
  };
}
